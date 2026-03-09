[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/0xchat-app/0xchat-core)

# 0xChat-Core

Welcome to 0xChat⚡️

0xchat is a secure chat app built on the [Nostr protocol](https://github.com/nostr-protocol/nips). It prioritizes privacy, featuring private key login, encrypted private chats and contacts, encrypted group chats, and private payments([Cashu](https://cashu.space/)). Additionally, it also offers an open communication platform through public channels.

0xchat Download links:

  - [0xchat on Appstore](https://apps.apple.com/app/0xchat/id1637607169)
  - [0xchat on Testflight](https://testflight.apple.com/join/AjdJFBmU)
  - [0xchat on Google play](https://play.google.com/store/apps/details?id=com.oxchat.nostr)
  - [0xchat APK download](https://github.com/0xchat-app/0xchat-app-main/releases)

![](https://github.com/0xchat-app/.github/blob/main/profile/banner.jpeg)

## Language & Platforms
The repository is primarily implemented in Dart, allowing you to swiftly create versions for iOS, Android, and Desktop.

## Getting Started
You can start by cloning this repository to your local machine using the command:

```git
git clone https://github.com/0xChat/0xChat-Core.git
```

## Modules
At present, the repository supports the following modules and functionalities:

1. **Account Module**: This module handles all account-related operations. It allows for account creation, user data requests, and caching of user information, among other features.

2. **Chat Module**: The chat module offers encrypted private chatting, encrypted contact lists, and open channels.
3. **Common Module**: The Common Module provides database integration and establishes connections with relay services.


## Nips Supported
- [x] [NIP 01 Basic protocol flow description](https://github.com/nostr-protocol/nips/blob/master/01.md)
- [x] [NIP 02 Contact List and Petnames](https://github.com/nostr-protocol/nips/blob/master/02.md)
- [x] [NIP 04 Encrypted Direct Message](https://github.com/nostr-protocol/nips/blob/master/04.md)
- [x] [NIP 05 Mapping Nostr keys to DNS-based internet identifiers](https://github.com/nostr-protocol/nips/blob/master/05.md)
- [x] [NIP 09 Event Deletion](https://github.com/nostr-protocol/nips/blob/master/09.md)
- [x] [NIP 10 On "e" and "p" tags in Text Events (kind 1)](https://github.com/nostr-protocol/nips/blob/master/10.md)
- [x] [NIP 13 Proof of Work](https://github.com/nostr-protocol/nips/blob/master/13.md)
- [x] [NIP 17 Private Direct Messages](https://github.com/nostr-protocol/nips/blob/master/17.md)
- [x] [NIP 18 Reposts](https://github.com/nostr-protocol/nips/blob/master/18.md)
- [x] [NIP 19 bech32-encoded entities](https://github.com/nostr-protocol/nips/blob/master/19.md)
- [x] [NIP 21 nostr: URI scheme](https://github.com/nostr-protocol/nips/blob/master/21.md)
- [x] [NIP 23 Long-form Content](https://github.com/nostr-protocol/nips/blob/master/23.md)
- [x] [NIP 25 Reactions](https://github.com/nostr-protocol/nips/blob/master/25.md)
- [x] [NIP 27 Text Note References](https://github.com/nostr-protocol/nips/blob/master/27.md)
- [x] [NIP 28 Public Chat](https://github.com/nostr-protocol/nips/blob/master/28.md)
- [x] [NIP 29 Relay-based Groups](https://github.com/nostr-protocol/nips/blob/master/29.md)
- [x] [NIP 30 Custom Emoji](https://github.com/nostr-protocol/nips/blob/master/30.md)
- [x] [NIP 33 Parameterized Replaceable Events](https://github.com/nostr-protocol/nips/blob/master/33.md)
- [x] [NIP 40 Expiration Timestamp](https://github.com/nostr-protocol/nips/blob/master/40.md)
- [x] [NIP 42 Authentication of clients to relays](https://github.com/nostr-protocol/nips/blob/master/42.md)
- [x] [NIP 44 Versioned Encryption](https://github.com/nostr-protocol/nips/blob/master/44.md)
- [x] [NIP 47 Wallet Connect](https://github.com/nostr-protocol/nips/blob/master/47.md)
- [x] [NIP 51 Lists](https://github.com/nostr-protocol/nips/blob/master/51.md)
- [x] [NIP 57 Lightning Zaps](https://github.com/nostr-protocol/nips/blob/master/57.md)
- [x] [NIP 58 Badges](https://github.com/nostr-protocol/nips/blob/master/58.md)
- [x] [NIP 59 Gift Wrap](https://github.com/nostr-protocol/nips/blob/master/59.md)
- [x] [NIP 65 Relay List Metadata](https://github.com/nostr-protocol/nips/blob/master/65.md)
- [x] [NIP 78 Application-specific data](https://github.com/nostr-protocol/nips/blob/master/78.md)
- [x] [NIP 96 HTTP File Storage Integration](https://github.com/nostr-protocol/nips/blob/master/96.md)
- [x] [NIP 98 HTTP Auth](https://github.com/nostr-protocol/nips/blob/master/98.md)


### Nips for 0xchat
- [x] [NIP 101 Alias Key Exchange](https://github.com/water783/nips/blob/nip101/101.md)
- [x] [NIP XXX Push Notifications](https://github.com/0xchat-app/0xchat-core/blob/main/doc/nofitications.md)
- [x] [NIP 100 WebRTC](https://github.com/jacany/nips/blob/webrtc/100.md)


## Future Enhancements

We continuously aim to improve and enhance the features. Stay tuned for future updates!

Some important planned features:

- [x] Threads, mentions, reactions
- [x] Zap Red Envelopes between friends
- [x] P2P audio/video calling
- [x] Private group
- [x] Cashu wallet Integration
- [x] Public/Private notes
- [x] Open/Closed groups
- [ ] Audio/video chat room
- [ ] Desktop&Tablets versions

## Support

We encourage contributions from the developer community! To contribute, please fork this repository, make your changes, and submit a pull request. 
If you encounter any issues or have questions, feel free to open an issue in this repository.

For more details and updates, please visit the official [0xChat website](https://www.0xchat.com).
