enum EMomentOptionType {
  reply,
  repost,
  like,
  zaps,
}

enum EMomentType {
  video,
  picture,
  quote,
  content,
}

enum ENotificationsMomentType {
  reply,
  repost,
  like,
  zaps,
  quote
}

enum EMomentQuoteType {
  repost,
  quote,
  share,
}

extension EMomentQuoteTypeEx on EMomentQuoteType{
  String get text {
    switch (this) {
      case EMomentQuoteType.repost:
        return 'Repost';
      case EMomentQuoteType.quote:
        return 'Quote';
      case EMomentQuoteType.share:
        return 'Share';
    }
  }

  String get getIconName {
    switch (this) {
      case EMomentQuoteType.repost:
        return 'repost_moment_icon.png';
      case EMomentQuoteType.quote:
        return 'quote_moment_icon.png';
      case EMomentQuoteType.share:
        return 'share_moment_icon.png';
    }
  }
}


extension ENotificationsMomentTypeEx on ENotificationsMomentType{
  String get text {
    switch (this) {
      case ENotificationsMomentType.reply:
        return 'Reply';
      case ENotificationsMomentType.repost:
        return 'Repost';
      case ENotificationsMomentType.like:
        return 'Like';
      case ENotificationsMomentType.zaps:
        return 'Zaps';
      case ENotificationsMomentType.quote:
        return 'Quote';
    }
  }

  String get getIconName {
    switch (this) {
      case ENotificationsMomentType.reply:
        return 'comment_moment_icon.png';
      case ENotificationsMomentType.repost:
        return 'repost_moment_icon.png';
      case ENotificationsMomentType.like:
        return 'like_moment_icon.png';
      case ENotificationsMomentType.zaps:
        return 'lightning_moment_icon.png';
      case ENotificationsMomentType.quote:
        return 'quote_moment_icon.png';
    }
  }
}


extension EMomentOptionTypeEx on EMomentOptionType{
  String get text {
    switch (this) {
      case EMomentOptionType.reply:
        return 'Reply';
      case EMomentOptionType.repost:
        return 'Repost';
      case EMomentOptionType.like:
        return 'Like';
      case EMomentOptionType.zaps:
        return 'Zaps';
    }
  }

  String get getIconName {
    switch (this) {
      case EMomentOptionType.reply:
        return 'comment_moment_icon.png';
      case EMomentOptionType.repost:
        return 'repost_moment_icon.png';
      case EMomentOptionType.like:
        return 'like_moment_icon.png';
      case EMomentOptionType.zaps:
        return 'lightning_moment_icon.png';
    }
  }
}

