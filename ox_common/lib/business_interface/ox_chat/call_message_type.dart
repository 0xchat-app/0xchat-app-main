
enum CallMessageType {
  audio,
  video
}

extension CallMessageTypeEx on CallMessageType{
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
}