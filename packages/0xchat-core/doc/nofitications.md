# NIP: XXX - Push Notifiation 

## Abstract

This NIP proposes a method for message push notifications using the NIP protocol, includes the sending and processing of heartbeat signals to detect online status and provide timely push notifications.



## Architecture


```mermaid
flowchart LR
    NostrClients --> |Kind 22456 event| Relay  
    Relay --> |Req response| PushServer--> |Notification| APNs --> |iOS notification| NostrClients
    PushServer --> |Notification| FCM--> |Android notification| NostrClients
    PushServer --> |Subscription |Relay
```

## Specification

### Push settings:

```json
{
"kind": 22456,
 "tags": [
   	["p", "push server pubkey"],
  ],
 "content": "<encrypted_text>?iv=<initialization_vector>"
}
```
The 'content' is encrypted using the NIP04 protocol. The decrypted content is as follows:

```json
{
    "online": 1,
    "kinds": "<list of event kinds to be notified about>",
    "deviceId": "<device token>",
    "relays": "<list of relays for the push server to subscribe to>",
    "#e": "<list of groups to be notified about>",
    "exclude_authors": "<list of pubkeys whose events must never be pushed>",
}

```
Upon receiving the encrypted message of 'kind' 22456, the push server decrypts it to obtain the subscription information (kinds, #e, #p) and the specified 'relays' to listen to. It then sends notifications to the device identified by the 'deviceId', using both APNs and FCM services.

### Excluding the subscriber's own events

A subscription matches events the subscriber published themselves. A channel
message they posted carries the channel's 'e' tag, and NIP-17 gift wraps a copy
of every outgoing message to the sender's own pubkey so that their other devices
stay in sync - that copy is p-tagged with the sender's pubkey and is therefore
indistinguishable from a real incoming message. Without a filter the subscriber
is notified that they "received a private message" for a message they just sent.

'exclude_authors' carries the subscriber's own pubkey(s). The push server must
drop any matched event signed by one of them before pushing it. The list travels
inside the NIP-04 encrypted payload, so it reveals nothing to relays or to third
parties.

### Push payload

The payload delivered to the device carries the rendered notification plus the
data the client needs to decide what to do with it:

```json
{
    "notification": {"title": "<title>", "body": "<body>"},
    "data": {
        "msgType": "<0 for a message, 1 for a call>",
        "sender": "<pubkey that signed the event, when the server can see it>"
    }
}

```
'sender' lets the client drop a notification for its own message if it reaches a
push server that does not yet honour 'exclude_authors'. It is omitted when the
author is not visible to the server, and clients must treat an absent 'sender'
as "unknown" rather than suppressing the notification.

### Heartbeat:

```json
{
    "online": 1
}

```
The heartbeat is sent at regular intervals, with the duration determined by the push service. If there is no heartbeat after a timeout, the device is considered offline. The push server will then start the push service.

### Offline

```json
{
    "online": 0
}

```
When a device needs to go offline immediately, set 'online' to 0 and the push server will promptly initiate message push. 

Note: If 'online' is not set to 0, but the heartbeat timeout has occurred, it will also be treated as an offline state.


### Logout

```json
{
    "online": 0,
    "deviceId": ""
}

```

When a user logs out, there is no longer a need to receive push notifications, so the 'deviceId' should be set to an empty string.

## Rationale
This method makes full use of the NIP protocol to implement a push notification mechanism. By using the encrypted content in NIP04, it ensures the privacy and security of the user's data.

The use of heartbeat detection can promptly and accurately determine the online status of the device, providing efficient and accurate push notification services


## Implementation
[https://github.com/0xchat-app/0xchat-core/blob/main/lib/src/account/notification.dart](https://github.com/0xchat-app/0xchat-core/blob/main/lib/src/account/notification.dart)




