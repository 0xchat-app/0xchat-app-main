"""Read-only probe of Google Play Developer API access.

Confirms the service account authenticates and has the permissions the
publishing job will need, without uploading anything or changing any state.
The edit it opens is deleted again and is never committed, so nothing about
the app changes.
"""

import json
import os
import sys

import requests
from google.oauth2 import service_account
from google.auth.transport.requests import Request

PACKAGE = os.environ.get("PLAY_PACKAGE", "com.oxchat.nostr")
BASE = "https://androidpublisher.googleapis.com/androidpublisher/v3"
SCOPE = "https://www.googleapis.com/auth/androidpublisher"


def describe(resp):
    """Render an API error without braces.

    A multi-line JSON secret makes GitHub treat every line of it as a secret,
    including the lines that are just "{" and "}", so any raw JSON echoed into
    the log comes out as ***. Pull the fields out and print them as plain text.
    """
    try:
        err = resp.json().get("error", {})
        parts = [f"status={err.get('status')}", f"message={err.get('message')}"]
        for d in err.get("details", []) or []:
            reason = d.get("reason")
            if reason:
                parts.append(f"reason={reason}")
        return f"HTTP {resp.status_code} " + " | ".join(str(p) for p in parts)
    except Exception:
        safe = resp.text[:300].replace("{", "(").replace("}", ")")
        return f"HTTP {resp.status_code} {safe}"


def fail(msg, resp=None):
    print(f"::error::{msg}")
    if resp is not None:
        print("  " + describe(resp))
    sys.exit(1)


def main():
    raw = os.environ.get("PLAY_SERVICE_ACCOUNT_JSON", "")
    if not raw.strip():
        fail("PLAY_SERVICE_ACCOUNT_JSON is empty")

    try:
        info = json.loads(raw)
    except json.JSONDecodeError as e:
        fail(f"PLAY_SERVICE_ACCOUNT_JSON is not valid JSON: {e}")

    # Identifying fields only - never the private key.
    print(f"service account: {info.get('client_email')}")
    print(f"project:         {info.get('project_id')}")
    print(f"package:         {PACKAGE}")
    print()

    creds = service_account.Credentials.from_service_account_info(info, scopes=[SCOPE])
    try:
        creds.refresh(Request())
    except Exception as e:
        fail(f"could not obtain an access token: {e}")
    print("[1/4] authentication OK")

    s = requests.Session()
    s.headers["Authorization"] = f"Bearer {creds.token}"

    r = s.post(f"{BASE}/applications/{PACKAGE}/edits", timeout=60)
    if r.status_code == 403:
        fail(
            "403 from Play. The service account authenticated, but has no access to "
            f"{PACKAGE}. Invite its email under Play Console -> Users and permissions "
            "and grant Release manager on this app.",
            r,
        )
    if r.status_code == 404:
        fail(f"404 - Play does not know package {PACKAGE} for this account.", r)
    if not r.ok:
        fail("unexpected error opening an edit", r)
    edit_id = r.json()["id"]
    print("[2/4] edit opened, so release permissions are in place")

    version_codes = []
    try:
        r = s.get(f"{BASE}/applications/{PACKAGE}/edits/{edit_id}/tracks", timeout=60)
        if not r.ok:
            fail("could not list tracks", r)
        print("[3/4] tracks:")
        for track in r.json().get("tracks", []):
            releases = track.get("releases", [])
            if not releases:
                print(f"      {track['track']:<12} (no releases)")
            for rel in releases:
                codes = rel.get("versionCodes") or []
                version_codes += [int(c) for c in codes]
                print(
                    f"      {track['track']:<12} status={rel.get('status'):<10} "
                    f"name={rel.get('name', '-'):<12} versionCodes={codes}"
                )
    finally:
        # Abandon the edit; nothing was committed so the app is untouched.
        s.delete(f"{BASE}/applications/{PACKAGE}/edits/{edit_id}", timeout=60)
        print("      (edit discarded)")

    if not version_codes:
        print("[4/4] no existing releases, so nothing to probe for signed APKs")
        return

    highest = max(version_codes)
    print(f"[4/4] generatedApks for highest existing versionCode {highest}:")
    r = s.get(f"{BASE}/applications/{PACKAGE}/generatedApks/{highest}", timeout=60)
    if r.status_code == 404:
        print("      none - Play App Signing may be off, or Play has not generated them")
        return
    if not r.ok:
        fail("could not list generated APKs", r)

    for entry in r.json().get("generatedApks", []):
        print(f"      signing cert SHA-256: {entry.get('certificateSha256Hash')}")
        universal = entry.get("generatedUniversalApk")
        if universal:
            print(f"      universal APK downloadId: {universal.get('downloadId')}")
            print("      -> a Play-signed universal APK can be fetched automatically")
        else:
            print("      no universal APK for this version")
        splits = entry.get("generatedSplitApks") or []
        print(f"      split APKs available: {len(splits)}")

    print()
    print("All checks passed. Nothing was uploaded and no state was changed.")


if __name__ == "__main__":
    main()
