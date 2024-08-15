
enum CustomMessageType {
  zaps,
  call,
  template,
  note,
  ecash,    // normal token
  ecashV2,  // support specifying recipient & signature
  imageSending,
}

extension CustomMessageTypeEx on CustomMessageType {
  String get value {
    switch (this) {
      case CustomMessageType.zaps:
        return '1';
      case CustomMessageType.call:
        return '2';
      case CustomMessageType.template:
        return '3';
      case CustomMessageType.note:
        return '4';
      case CustomMessageType.ecash:
        return '5';
      case CustomMessageType.ecashV2:
        return '6';
      case CustomMessageType.imageSending:
        return '7';
      default:
        return '-1';
    }
  }

  static CustomMessageType? fromValue(dynamic value) {
    try {
      return CustomMessageType.values.firstWhere((e) => e.value == value);
    } catch(e) {
      return null;
    }
  }
}