## **Private Group - Beta Version**

We're introducing the "Private Group," which requires no new NIP (Only Adding New Tags). It is a combination of [NIP-28](https://github.com/nostr-protocol/nips/blob/master/28.md) and [NIP-24](https://github.com/vitorpamplona/nips/blob/sealed-dms/24.md).

### **Key Features**:
- **Anonymity**: Members are anonymous externally but identifiable within the group.
- **Privacy**: All messages are gift-wrapped, and individually delivered to each group member.
- **Ideal Size**: Best suited for groups with fewer than 500 members.

### **1. Group Creation (Kind 40)**

Creating a group is the same as creating a channel, with no changes required.

```json
{
    "content": "{\"name\": \"Demo Group\", \"about\": \"A test group.\", \"picture\": \"https://placekitten.com/200/200\"}",
    ...
}
```

### **2. Group Metadata (Kind 41)**

The metadata is the same as channel metadata, with the only difference being the addition of the 'm' tag to declare group members.

```json
{
    "content": "{\"name\": \"Updated Demo Group\", \"about\": \"Updating a test group.\", \"picture\": \"https://placekitten.com/201/201\"}",
    "tags": [
        ["e", "<group_create_event_id>", "<relay-url>"],
        ["m", "<group_member_pubkey1>", "owner"],
        ["m", "<group_member_pubkey2>"],
        ["m", "<group_member_pubkey3>"],
    ],
    ...
}
```

### **3. Group Message (Kind 42)**

Group messages are the same as channel messages, with the only difference being the addition of the **optional** 'type' tag to declare the system message type, such as join, leave, request, etc.

```json
{
    "content": "<string>",
    "tags": [
        ["e", "<kind_40_event_id>", "<relay-url>", "root"],
        ["e", "<kind_42_event_id>", "<relay-url>", "reply"],
        ["p", "<pubkey>", "<relay-url>"],
        ["type", "join"]
        ...
    ],
    ...
}
```