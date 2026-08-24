"""Upload an app bundle to Google Play and fetch back the Play-signed APK.

Play App Signing means Google re-signs the delivered artifacts with a key we
do not hold, so an APK built here can never carry the signature users already
have installed. The only way to publish an APK elsewhere (GitHub releases,
Zapstore) that can upgrade a Play install is to let Play sign it and download
the result, which is what --download does.

Runs as a dry run unless --commit is passed: it opens an edit, uploads the
bundle, sets up the release, and then discards the edit. Play validates the
upload either way, but nothing is published and - importantly - no version
code is consumed, since Play only records one when the edit is committed.
"""

import argparse
import json
import os
import sys
import time

import requests
from google.oauth2 import service_account
from google.auth.transport.requests import Request

BASE = "https://androidpublisher.googleapis.com/androidpublisher/v3"
UPLOAD = "https://androidpublisher.googleapis.com/upload/androidpublisher/v3"
SCOPE = "https://www.googleapis.com/auth/androidpublisher"


def describe(resp):
    """Render an API error without braces.

    A multi-line JSON secret makes GitHub mask every line of it, the bare "{"
    and "}" lines included, so raw JSON echoed to the log arrives as ***.
    """
    try:
        err = resp.json().get("error", {})
        bits = [f"status={err.get('status')}", f"message={err.get('message')}"]
        return f"HTTP {resp.status_code} " + " | ".join(str(b) for b in bits)
    except Exception:
        return f"HTTP {resp.status_code} " + resp.text[:300].replace("{", "(").replace("}", ")")


def fail(msg, resp=None):
    print(f"::error::{msg}")
    if resp is not None:
        print("  " + describe(resp))
    sys.exit(1)


def session():
    raw = os.environ.get("PLAY_SERVICE_ACCOUNT_JSON", "")
    if not raw.strip():
        fail("PLAY_SERVICE_ACCOUNT_JSON is empty")
    creds = service_account.Credentials.from_service_account_info(
        json.loads(raw), scopes=[SCOPE]
    )
    creds.refresh(Request())
    s = requests.Session()
    s.headers["Authorization"] = f"Bearer {creds.token}"
    return s


def highest_version_code(s, pkg, edit_id):
    r = s.get(f"{BASE}/applications/{pkg}/edits/{edit_id}/tracks", timeout=60)
    if not r.ok:
        fail("could not list tracks", r)
    codes = []
    for track in r.json().get("tracks", []):
        for rel in track.get("releases", []):
            codes += [int(c) for c in rel.get("versionCodes") or []]
    return max(codes) if codes else 0


def download_signed_apk(s, pkg, version_code, out_dir, expect_cert, tries, delay):
    """Play generates the signed artifacts asynchronously, so poll for them."""
    for attempt in range(1, tries + 1):
        r = s.get(f"{BASE}/applications/{pkg}/generatedApks/{version_code}", timeout=60)
        entries = r.json().get("generatedApks", []) if r.ok else []
        universal = None
        for entry in entries:
            cert = entry.get("certificateSha256Hash")
            if expect_cert and cert and cert.replace(":", "").lower() != expect_cert.replace(":", "").lower():
                print(f"  skipping artifacts signed by {cert}")
                continue
            if entry.get("generatedUniversalApk"):
                universal = (entry["generatedUniversalApk"]["downloadId"], cert)
                break
        if universal:
            download_id, cert = universal
            print(f"  signed by {cert}")
            url = (f"{BASE}/applications/{pkg}/generatedApks/{version_code}"
                   f"/downloads/{download_id}:download")
            r = s.get(url, params={"alt": "media"}, stream=True, timeout=600)
            if not r.ok:
                fail("could not download the signed APK", r)
            os.makedirs(out_dir, exist_ok=True)
            path = os.path.join(out_dir, f"oxchat-play-signed-{version_code}.apk")
            with open(path, "wb") as fh:
                for chunk in r.iter_content(1 << 20):
                    fh.write(chunk)
            print(f"  wrote {path} ({os.path.getsize(path) / 1048576:.1f} MB)")
            return path
        print(f"  not generated yet ({attempt}/{tries}), waiting {delay}s")
        time.sleep(delay)
    fail(f"Play never produced a universal APK for versionCode {version_code}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--package", default="com.oxchat.nostr")
    ap.add_argument("--aab", help="path to the .aab to upload")
    ap.add_argument("--version-code", type=int, required=True)
    ap.add_argument("--track", default="internal")
    ap.add_argument("--release-name", default=None)
    ap.add_argument("--commit", action="store_true",
                    help="actually publish; without it the edit is discarded")
    ap.add_argument("--download", action="store_true",
                    help="after committing, fetch the Play-signed universal APK")
    ap.add_argument("--out-dir", default="dist")
    ap.add_argument("--expect-cert", default=os.environ.get("PLAY_SIGNING_CERT_SHA256", ""))
    ap.add_argument("--poll-tries", type=int, default=30)
    ap.add_argument("--poll-delay", type=int, default=60)
    args = ap.parse_args()

    s = session()
    pkg = args.package
    mode = "PUBLISH" if args.commit else "DRY RUN (edit will be discarded)"
    print(f"mode:    {mode}")
    print(f"package: {pkg}")
    print(f"track:   {args.track}")
    print(f"version: {args.version_code}")
    print()

    r = s.post(f"{BASE}/applications/{pkg}/edits", timeout=60)
    if not r.ok:
        fail("could not open an edit", r)
    edit_id = r.json()["id"]
    committed = False

    try:
        current = highest_version_code(s, pkg, edit_id)
        print(f"highest versionCode already on Play: {current}")
        if args.version_code <= current:
            fail(
                f"versionCode {args.version_code} is not greater than {current}. "
                "Play only accepts an increasing versionCode - bump the build "
                "number in pubspec.yaml."
            )
        print(f"{args.version_code} > {current}, so Play will accept it")

        if not args.aab:
            fail("--aab is required")
        size = os.path.getsize(args.aab) / 1048576
        print(f"uploading {args.aab} ({size:.1f} MB)")
        with open(args.aab, "rb") as fh:
            r = s.post(
                f"{UPLOAD}/applications/{pkg}/edits/{edit_id}/bundles",
                params={"uploadType": "media"},
                headers={"Content-Type": "application/octet-stream"},
                data=fh,
                timeout=1800,
            )
        if not r.ok:
            fail("Play rejected the bundle", r)
        uploaded = int(r.json()["versionCode"])
        print(f"accepted as versionCode {uploaded}")
        if uploaded != args.version_code:
            fail(f"bundle carries versionCode {uploaded}, expected {args.version_code}")

        body = {
            "releases": [{
                "versionCodes": [str(uploaded)],
                "status": "draft",
                "name": args.release_name or str(uploaded),
            }]
        }
        r = s.put(
            f"{BASE}/applications/{pkg}/edits/{edit_id}/tracks/{args.track}",
            json=body, timeout=60,
        )
        if not r.ok:
            fail(f"could not stage the release on the {args.track} track", r)
        print(f"staged as a draft release on {args.track}")

        if not args.commit:
            print()
            print("Dry run: discarding the edit. Play validated the bundle, but "
                  "nothing was published and versionCode "
                  f"{args.version_code} is still free.")
            return

        r = s.post(f"{BASE}/applications/{pkg}/edits/{edit_id}:commit", timeout=300)
        if not r.ok:
            fail("could not commit the edit", r)
        committed = True
        print("committed - the release exists on Play as a draft")
    finally:
        if not committed:
            s.delete(f"{BASE}/applications/{pkg}/edits/{edit_id}", timeout=60)

    if args.download:
        print()
        print("waiting for Play to generate the signed APKs")
        download_signed_apk(s, pkg, args.version_code, args.out_dir,
                            args.expect_cert, args.poll_tries, args.poll_delay)


if __name__ == "__main__":
    main()
