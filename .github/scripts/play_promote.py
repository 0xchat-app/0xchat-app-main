"""Release a version code that is already on Google Play to a track.

play_publish.py uploads each tagged build and leaves it as a draft on the
internal track. This takes such a version code and releases it on another
track (production by default), optionally as a staged rollout, together with
its "What's new" text.

Runs as a dry run unless --commit is passed: it opens an edit, prints the
app's store languages and what every track currently serves, sets up the
release, and then discards the edit, so nothing on Play changes.

Release notes come from --notes-dir, one file per language named after the
Play language code (en-US.txt, zh-CN.txt, ...), each at most 500 characters.
"""

import argparse
import json
import os
import sys

import requests
from google.oauth2 import service_account
from google.auth.transport.requests import Request

BASE = "https://androidpublisher.googleapis.com/androidpublisher/v3"
SCOPE = "https://www.googleapis.com/auth/androidpublisher"
NOTES_LIMIT = 500


def describe(resp):
    """Render an API error without braces (see play_publish.py: GitHub masks
    the "{" / "}" lines of the multi-line JSON secret, so raw JSON comes out
    as ***)."""
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


def read_notes(notes_dir):
    notes = []
    if not notes_dir:
        return notes
    if not os.path.isdir(notes_dir):
        fail(f"release notes directory {notes_dir} does not exist")
    for name in sorted(os.listdir(notes_dir)):
        if not name.endswith(".txt"):
            continue
        language = name[:-len(".txt")]
        with open(os.path.join(notes_dir, name), encoding="utf-8") as fh:
            text = fh.read().strip()
        if not text:
            fail(f"{name} is empty")
        if len(text) > NOTES_LIMIT:
            fail(f"{name} is {len(text)} characters; Play allows {NOTES_LIMIT}")
        notes.append({"language": language, "text": text})
    if not notes:
        fail(f"no <language>.txt files in {notes_dir}")
    return notes


def print_tracks(s, pkg, edit_id):
    r = s.get(f"{BASE}/applications/{pkg}/edits/{edit_id}/tracks", timeout=60)
    if not r.ok:
        fail("could not list tracks", r)
    for track in r.json().get("tracks", []):
        releases = track.get("releases", []) or [{}]
        for rel in releases:
            codes = ",".join(rel.get("versionCodes") or []) or "-"
            fraction = f" {rel['userFraction'] * 100:g}%" if "userFraction" in rel else ""
            print(f"  {track['track']:<12} {rel.get('status', 'empty'):<11}{fraction:<6} "
                  f"versionCodes={codes} name={rel.get('name', '-')}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--package", default="com.oxchat.nostr")
    ap.add_argument("--version-code", type=int, required=True)
    ap.add_argument("--track", default="production")
    ap.add_argument("--rollout", type=float, default=100.0,
                    help="percentage of users; 100 releases to everyone")
    ap.add_argument("--release-name", default=None)
    ap.add_argument("--notes-dir", default=None)
    ap.add_argument("--commit", action="store_true",
                    help="actually release; without it the edit is discarded")
    args = ap.parse_args()

    if not 0 < args.rollout <= 100:
        fail(f"--rollout must be in (0, 100], got {args.rollout:g}")
    notes = read_notes(args.notes_dir)

    s = session()
    pkg = args.package
    print(f"mode:    {'RELEASE' if args.commit else 'DRY RUN (edit will be discarded)'}")
    print(f"package: {pkg}")
    print(f"track:   {args.track}")
    print(f"version: {args.version_code}")
    print(f"rollout: {args.rollout:g}%")
    print()

    r = s.post(f"{BASE}/applications/{pkg}/edits", timeout=60)
    if not r.ok:
        fail("could not open an edit", r)
    edit_id = r.json()["id"]
    committed = False

    try:
        r = s.get(f"{BASE}/applications/{pkg}/edits/{edit_id}/details", timeout=60)
        default_language = r.json().get("defaultLanguage", "?") if r.ok else "?"
        r = s.get(f"{BASE}/applications/{pkg}/edits/{edit_id}/listings", timeout=60)
        if not r.ok:
            fail("could not list the store listings", r)
        languages = sorted(l["language"] for l in r.json().get("listings", []))
        print(f"default language: {default_language}")
        print(f"store languages:  {', '.join(languages)}")
        print()
        print("tracks before:")
        print_tracks(s, pkg, edit_id)
        print()

        r = s.get(f"{BASE}/applications/{pkg}/edits/{edit_id}/bundles", timeout=60)
        if not r.ok:
            fail("could not list the uploaded bundles", r)
        uploaded = {int(b["versionCode"]) for b in r.json().get("bundles", [])}
        if args.version_code not in uploaded:
            fail(f"versionCode {args.version_code} has not been uploaded to Play; "
                 "tag a release first so the build workflow uploads it")

        unknown = [n["language"] for n in notes if n["language"] not in languages]
        if unknown:
            fail(f"release notes for {', '.join(unknown)}, which the store listing "
                 f"does not have (it has {', '.join(languages)})")
        missing = [l for l in languages if l not in {n["language"] for n in notes}]
        if notes and missing:
            print(f"no release notes for {', '.join(missing)}; Play shows those users "
                  f"the {default_language} text")
        for n in notes:
            print(f"release notes [{n['language']}] ({len(n['text'])} chars):")
            print("  " + n["text"].replace("\n", "\n  "))
        print()

        release = {
            "versionCodes": [str(args.version_code)],
            "name": args.release_name or str(args.version_code),
            "releaseNotes": notes,
        }
        if args.rollout >= 100:
            release["status"] = "completed"
        else:
            release["status"] = "inProgress"
            release["userFraction"] = round(args.rollout / 100, 4)
        r = s.put(f"{BASE}/applications/{pkg}/edits/{edit_id}/tracks/{args.track}",
                  json={"releases": [release]}, timeout=60)
        if not r.ok:
            fail(f"Play refused the release on the {args.track} track", r)
        print(f"set up {args.version_code} on {args.track} as {release['status']}"
              + (f" ({args.rollout:g}%)" if release["status"] == "inProgress" else ""))

        if not args.commit:
            print()
            print("Dry run: discarding the edit, nothing on Play changed.")
            return

        r = s.post(f"{BASE}/applications/{pkg}/edits/{edit_id}:commit", timeout=300)
        if not r.ok:
            fail("could not commit the edit", r)
        committed = True
        print("committed - Play now reviews the release before it reaches users")
    finally:
        if not committed:
            s.delete(f"{BASE}/applications/{pkg}/edits/{edit_id}", timeout=60)

    r = s.post(f"{BASE}/applications/{pkg}/edits", timeout=60)
    if r.ok:
        check = r.json()["id"]
        print()
        print("tracks after:")
        print_tracks(s, pkg, check)
        s.delete(f"{BASE}/applications/{pkg}/edits/{check}", timeout=60)


if __name__ == "__main__":
    main()
