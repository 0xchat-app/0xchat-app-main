
part of 'chat_message_builder.dart';

extension ChatMessageBuilderReactionEx on ChatMessageBuilder {

  static Widget buildReactionsView(types.Message message, {
    required int messageWidth,
    Function(types.Reaction reaction)? itemOnTap,
  }) {
    if (!message.hasReactions) return SizedBox();

    final reactions = message.reactions;
    final zapsInfoList = message.zapsInfoList;
    final runSpacing = 8.px;
    return Padding(
      padding: EdgeInsets.only(left: 10.px, right: 10.px, bottom: 10.px - runSpacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reactions.isNotEmpty)
            Wrap(
              spacing: 8.px,
              runSpacing: runSpacing,
              children: reactions.map((reaction) => _buildReactionItem(reaction, itemOnTap)).toList(),
            ).setPaddingOnly(bottom: runSpacing),
          if (zapsInfoList.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: zapsInfoList.map(
                    (e) => _buildZapsItem(e).setPaddingOnly(bottom: runSpacing),
              ).toList(),
            ),
        ],
      ),
    );
  }

  static Widget _buildReactionItem(types.Reaction reaction, Function(types.Reaction reaction)? onTap) {
    const maxAuthorCount = 3;
    var reactionNames = <String>[];
    var reactionNamesLength = 0;
    var reactionNamesSuffix = '';
    bool isOverCount = false;
    for (final pubkey in reaction.authors) {
      final user = Account.sharedInstance.getUserInfo(pubkey);
      if (user is UserDBISAR) {
        var name = user.getUserShowName();
        if (name.length > 13) {
          name = name.substring(0, 10) + '...';
        }
        reactionNames.add(name);
        reactionNamesLength += name.length;
      }

      if (reactionNames.length >= maxAuthorCount || reactionNamesLength > 20) {
        isOverCount = true;
        break;
      }
    }

    final authorsCount = reaction.authors.length;
    if (isOverCount) {
      reactionNamesSuffix = ', ...... $authorsCount People';
    }

    return GestureDetector(
      onTap: () => onTap?.call(reaction),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 6.px,
          vertical: 2.px,
        ),
        decoration: BoxDecoration(
          color: ThemeColor.darkColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100.px),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              reaction.content,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(width: 4.px,),
            Text(
              reactionNames.join(', ') + reactionNamesSuffix,
              style: TextStyle(
                  fontSize: 10.sp,
                  color: ThemeColor.white
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildZapsItem(types.ZapsInfo zapsInfo) {
    final text = '${zapsInfo.author.getUserShowName()} zaps ${zapsInfo.amount} ${zapsInfo.unit}';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.px,
        vertical: 2.px,
      ),
      decoration: BoxDecoration(
        color: ThemeColor.darkColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(100.px),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonImage(
            iconName: 'icon_message_reactions_zaps.png',
            size: 14.px,
            package: 'ox_chat',
          ),
          SizedBox(width: 4.px,),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              color: ThemeColor.white,
            ),
          ),
        ],
      ),
    );
  }
}