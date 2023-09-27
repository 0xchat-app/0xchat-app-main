
enum CallMessageType {
  audio,
  video
}

extension CallMessageTypeEx on CallMessageType {
  String get text {
    switch (this) {
      case CallMessageType.audio:
        return 'audio';
      case CallMessageType.video:
        return 'video';
      default:
        return 'unknow';
    }
  }

  String get value {
    switch (this) {
      case CallMessageType.audio:
        return 'audio';
      case CallMessageType.video:
        return 'video';
      default:
        return 'unknow';
    }
  }

  static CallMessageType? fromValue(dynamic value) {
    try {
      return CallMessageType.values.firstWhere((e) => e.value == value);
    } catch(e) {
      return null;
    }
  }
}