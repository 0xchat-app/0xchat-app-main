# 0xchat

A secure, open-source chat app built on the [Nostr](https://nostr.com) protocol.

Available on **Android · iOS · macOS · Linux · Windows**.

## Reliable Hosting

Since Nostr servers are heavily spammed, for reliable media hosting we recommend self-hosting your own media distributor using [Originless](https://github.com/besoeasy/Originless) and adding it as your own server in 0xchat.

## Project Layout

0xchat is a single repository. Every package it builds on lives under
`packages/` and is wired up as a local path dependency, so a plain `git clone`
gives you the whole tree — there are no submodules to initialise:

| Path | Contents |
| --- | --- |
| `packages/0xchat-core` | Nostr client core (`chatcore`) |
| `packages/nostr-dart` | Nostr protocol library (`nostr_core_dart`) |
| `packages/cashu-dart` | Cashu ecash library (`cashu_dart`) |
| `packages/base_framework/*` | Shared infrastructure: common, theme, network, cache manager, localizable, module service, push |
| `packages/business_modules/*` | Features: home, login, chat, chat UI, usercenter, discovery, calling, wallet |

A change spanning several of these is a single pull request.

## Getting Started

Requires Flutter `3.29.3`.

**1. Install dependencies**

```sh
flutter pub get
```

(`sh ox_pub_get.sh` still works and does the same thing.)

**2. iOS / macOS — install CocoaPods dependencies**

```sh
(cd ios && pod install)   # iOS
(cd macos && pod install) # macOS
```

**3. Build**

```sh
flutter build apk       # Android
flutter build ios       # iOS
flutter build macos     # macOS
flutter build linux     # Linux
flutter build windows   # Windows
```

**Build and test with Docker (Linux only)**

Use the included Dockerfile to build and test in a clean container without
installing Flutter or system build dependencies on your machine.

```sh
docker build -t oxchat-linux-builder . && docker run --rm -v "$PWD":/workspace -v /tmp/oxchat-pub-cache:/root/.pub-cache oxchat-linux-builder && ./build/linux/x64/release/bundle/oxchat_app_main
```

