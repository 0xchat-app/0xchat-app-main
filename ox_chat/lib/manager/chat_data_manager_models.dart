
import 'package:flutter/foundation.dart';

abstract class ChatTypeKey {
  // DB Option
  String getSQLFilter();
  List<String> getSQLFilterArgs();

  // Equatable
  bool operator ==(Object other);
  int get hashCode;
}

@immutable
class PrivateChatKey implements ChatTypeKey {
  final String userId1;
  final String userId2;

  PrivateChatKey(this.userId1, this.userId2);

  String getSQLFilter() {
    return ' (sender = ? AND receiver = ? ) OR (sender = ? AND receiver = ? ) ';
  }

  List<String> getSQLFilterArgs() {
    return [userId1, userId2, userId2, userId1];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrivateChatKey &&
        ((other.userId1 == userId1 && other.userId2 == userId2) || (other.userId1 == userId2 && other.userId2 == userId1));
  }

  @override
  int get hashCode => userId1.hashCode ^ userId2.hashCode;
}

@immutable
class ChannelKey implements ChatTypeKey {
  final String groupId;

  ChannelKey(this.groupId);

  String getSQLFilter() {
    return ' groupId = ? ';
  }

  List<String> getSQLFilterArgs() {
    return [groupId];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChannelKey && other.groupId == groupId;
  }

  @override
  int get hashCode => groupId.hashCode;
}

@immutable
class SecretChatKey implements ChatTypeKey {
  final String sessionId;

  SecretChatKey(this.sessionId);

  String getSQLFilter() {
    return ' sessionId = ? ';
  }

  List<String> getSQLFilterArgs() {
    return [sessionId];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SecretChatKey && other.sessionId == sessionId;
  }

  @override
  int get hashCode => sessionId.hashCode;
}

abstract class ChatDataManagerObserver  {

}