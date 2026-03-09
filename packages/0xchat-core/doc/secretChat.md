## **Secret Chat - Beta Version**

#### **1. End-to-End Encryption**
 
Utilizes the [NIP-44](https://github.com/staab/nips/blob/NIP-44/44.md) encryption protocol to replace [NIP-4](https://github.com/nostr-protocol/nips/blob/master/04.md).
  
#### **2. Metadata Leak Prevention**

All messages are wrapped using the [NIP-59](https://github.com/nostr-protocol/nips/blob/fd914c600fd590e6188534cd7555116da7855503/59.md) protocol, ensuring that metadata is not leaked.
  
#### **3. Forward Secrecy**

When initiating a secure chat mode, we employ the [NIP-101](https://github.com/water783/nips/blob/nip101/101.md) protocol to exchange alias keys and locally compute the shared key for the chat. Messages are then encrypted and transmitted using this shared key. Periodic key updates are performed following a set of rules to ensure that even if the shared key is compromised at any given time, not all chat records can be decrypted.
  
#### **4. Irrecoverability on Other Devices**

The shared key for each secure chat session is stored locally. If the app is uninstalled or the device is changed, the secure chat history becomes irretrievable.

#### **5. Screenshot Detection**

During a secure chat, if a screenshot is detected, an automatic notification is sent to the counterparty.
  
#### **6. Specific Relay for Secure Chat Messages**

When establishing a secure chat, users can opt to send messages exclusively through a specific relay. By agreeing upon a relay, both parties can further enhance security and privacy.

-- 

For any additional details or clarifications, please refer to the respective NIP protocol documentation.

- NIP-44: [https://github.com/staab/nips/blob/NIP-44/44.md](https://github.com/staab/nips/blob/NIP-44/44.md)
- NIP-59: [https://github.com/nostr-protocol/nips/blob/fd914c600fd590e6188534cd7555116da7855503/59.md](https://github.com/nostr-protocol/nips/blob/fd914c600fd590e6188534cd7555116da7855503/59.md)
- NIP-101: [https://github.com/water783/nips/blob/nip101/101.md](https://github.com/water783/nips/blob/nip101/101.md)
