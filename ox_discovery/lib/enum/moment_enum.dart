enum EMomentOptionType {
  reply,
  repost,
  like,
  zaps,
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

