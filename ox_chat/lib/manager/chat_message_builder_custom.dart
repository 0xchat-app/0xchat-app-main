
part of 'chat_message_builder.dart';

extension ChatMessageBuilderCustomEx on ChatMessageBuilder {
  static TextSpan buildTextSpan(String text) {
    RegExp regExp = RegExp(r"#\w+|https?://\S+|nostr:\S+");
    Iterable<RegExpMatch> matches = regExp.allMatches(text);

    List<TextSpan> spans = [];
    int start = 0;

    matches.forEach((match) {
      spans.add(TextSpan(text: text.substring(start, match.start)));

      var matchedText = text.substring(match.start, match.end);
      spans.add(TextSpan(
          text: matchedText,
          style: TextStyle(
            color: Color(0xFFC084FC),
          )));

      start = match.end;
    });

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start, text.length)));
    }

    return TextSpan(children: spans, style: TextStyle(
      fontSize: 14.sp,
      color: ThemeColor.color0,
      height: 1.4,
    ));
  }

  static Widget _buildZapsMessage(types.CustomMessage message, Widget reactionWidget) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ThemeColor.gradientMainEnd,
            ThemeColor.gradientMainStart
          ],
        ),
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildZapsMessageContent(message),
            reactionWidget,
          ],
        ),
      ),
    );
  }

  static Widget _buildZapsMessageContent(types.CustomMessage message) {
    final amount = ZapsMessageEx(message).amount.formatWithCommas();
    final description = ZapsMessageEx(message).description;
    return Container(
      height: 86.px,
      constraints: BoxConstraints(minWidth: 240.px),
      padding: EdgeInsets.symmetric(
        horizontal: 10.px,
      ),
      margin: EdgeInsets.only(
        bottom: message.hasReactions ? 10.px : 0,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                CommonImage(
                  iconName: 'icon_zaps_logo.png',
                  package: 'ox_chat',
                  size: Adapt.px(32),
                ).setPadding(EdgeInsets.only(right: Adapt.px(10))),
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$amount Sats', style: TextStyle(color: ThemeColor.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),),
                    Text(description,
                      style: TextStyle(color: ThemeColor.white, fontSize: 12),),
                  ],
                ))
              ],
            ),
          ),
          Container(
            color: ThemeColor.white.withOpacity(0.5),
            height: 0.5,
          ),
          Container(
            height: Adapt.px(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Localized.text('ox_chat.lightning_invoice'),
                  style: TextStyle(color: ThemeColor.white, fontSize: 12),),
                CommonImage(iconName: 'icon_zaps_0xchat.png',
                  package: 'ox_chat',
                  size: Adapt.px(16),)
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildCallMessage(types.CustomMessage message, bool isMe) {
    final text = CallMessageEx(message).callText;
    final type = CallMessageEx(message).callType;
    final tintColor = isMe ? ThemeColor.white : ThemeColor.color0;
    return Container(
      padding: EdgeInsets.all(Adapt.px(10)),
      decoration: isMe ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ThemeColor.gradientMainEnd,
            ThemeColor.gradientMainStart,
          ],
        ),
      ) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
                color: tintColor,
                fontSize: 14
            ),
          ).setPadding(EdgeInsets.only(right: Adapt.px(10))),
          CommonImage(
            iconName: type?.iconName ?? '',
            size: Adapt.px(20),
            color: tintColor,
            package: OXChatInterface.moduleName,
          ),
        ],
      ),
    );
  }

  static Widget _buildTemplateMessage(types.CustomMessage message, Widget reactionWidget, bool isMe) {
    final title = TemplateMessageEx(message).title;
    final content = TemplateMessageEx(message).content;
    final icon = TemplateMessageEx(message).icon;
    Widget iconWidget = SizedBox();
    if (icon.isNotEmpty) {
      if (icon.isRemoteURL) {
        iconWidget = OXCachedNetworkImage(
          imageUrl: icon,
          height: 48.px,
          width: 48.px,
          fit: BoxFit.cover,
        ).setPadding(EdgeInsets.only(left: 10.px));
      }
      else {
        iconWidget = CommonImage(
          iconName: icon,
          fit: BoxFit.contain,
          height: 48.px,
          width: 48.px,
          package: 'ox_common',
        ).setPadding(EdgeInsets.only(left: 10.px));
      }
    }
    return Container(
      width: 266.px,
      color: ThemeColor.color180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ThemeColor.color0,
                  height: 1.4,
                ),
              ),
              Container(color: ThemeColor.color160, height: 0.5,)
                  .setPadding(EdgeInsets.symmetric(vertical: 4.px)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ThemeColor.color60,
                        height: 1.4,
                      ),
                    ),
                  ),
                  iconWidget,
                ],
              ),
            ],
          ).setPadding(EdgeInsets.all(10.px)),
          reactionWidget,
        ],
      ),
    );
  }

  static Widget _buildNoteMessage(types.CustomMessage message, Widget reactionWidget, bool isMe) {
    final title = NoteMessageEx(message).authorName;
    final authorIcon = NoteMessageEx(message).authorIcon;
    final dns = NoteMessageEx(message).authorDNS;
    final createTime = NoteMessageEx(message).createTime;
    final content = NoteMessageEx(message).note;
    final icon = NoteMessageEx(message).image;
    Widget iconWidget = SizedBox().setPadding(EdgeInsets.only(bottom: 10.px));
    if (icon.isNotEmpty) {
      if (icon.isRemoteURL) {
        iconWidget = OXCachedNetworkImage(
          imageUrl: icon,
          height: 139.px,
          width: 265.px,
          fit: BoxFit.fitWidth,
        ).setPadding(EdgeInsets.only(bottom: 8.px));
      }
      else {
        iconWidget = CommonImage(
          iconName: icon,
          fit: BoxFit.contain,
          height: 139.px,
          width: 265.px,
          package: 'ox_common',
        ).setPadding(EdgeInsets.only(bottom: 8.px));
      }
    }
    return Container(
      width: 266.px,
      color: ThemeColor.color180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                    child: OXCachedNetworkImage(
                      imageUrl: authorIcon,
                      height: 20.px,
                      width: 20.px,
                    )).setPadding(EdgeInsets.only(right: 4.px)),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 100.px,
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeColor.color0,
                        height: 1.4
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ).setPadding(EdgeInsets.only(right: 4.px)),
                ),
                Expanded(
                  child: Text(
                    dns,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeColor.color120,
                        height: 1.4
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Spacer(),
                Text(
                  OXDateUtils.convertTimeFormatString2(createTime * 1000,
                      pattern: 'MM-dd'),
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: ThemeColor.color120,
                      height: 1.4
                  ),
                  textAlign: TextAlign.center,
                )
              ]).setPadding(EdgeInsets.only(left: 10.px, right: 10.px)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: buildTextSpan(content),
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ).setPadding(EdgeInsets.only(top: 2.px, left: 10.px, right: 10.px, bottom: 10.px)),
          reactionWidget,
        ],
      ),
    );
  }

  static Widget _buildEcashMessage(types.CustomMessage message, Widget reactionWidget, bool isMe) {
    final description = EcashMessageEx(message).description;
    final isOpened = EcashMessageEx(message).isOpened;
    return Opacity(
      opacity: isOpened ? 0.5 : 1,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: Adapt.px(240),
              height: Adapt.px(86),
              padding: EdgeInsets.symmetric(
                horizontal: 10.px,
              ),
              margin: EdgeInsets.only(
                bottom: message.hasReactions ? 10.px : 0,
              ),
              child: Column(
                children: [
                  Expanded(child: Row(
                    children: [
                      CommonImage(
                        iconName: 'icon_cashu_logo.png',
                        package: 'ox_chat',
                        size: Adapt.px(32),
                      ).setPadding(EdgeInsets.only(right: Adapt.px(10))),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: TextStyle(
                              color: ThemeColor.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          Visibility(
                            visible: isOpened,
                            child: Text(
                              'ecash_redeemed'.localized(),
                              style: TextStyle(
                                color: ThemeColor.white,
                                fontSize: 12.sp,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
                  )),
                  Container(
                    color: ThemeColor.white.withOpacity(0.5),
                    height: 0.5,
                  ),
                  Container(
                    height: Adapt.px(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ecash_token_name'.localized(),
                          style: TextStyle(color: ThemeColor.white, fontSize: 12),),
                        CommonImage(iconName: 'icon_zaps_0xchat.png',
                          package: 'ox_chat',
                          size: Adapt.px(16),)
                      ],
                    ),
                  )
                ],
              ),
            ),
            reactionWidget,
          ],
        ),
      ),
    );
  }

  static Widget _buildEcashV2Message(types.CustomMessage message, Widget reactionWidget) {
    final isOpened = EcashV2MessageEx(message).isOpened;
    final opacity = isOpened ? 0.5 : 1.0;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ThemeColor.gradientMainEnd.withOpacity(opacity),
            ThemeColor.gradientMainStart.withOpacity(opacity),
          ],
        ),
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEcashV2MessageContent(message, opacity),
            reactionWidget,
          ],
        ),
      ),
    );
  }

  static Widget _buildEcashV2MessageContent(types.CustomMessage message, double opacity) {
    final description = EcashV2MessageEx(message).description;
    final isOpened = EcashV2MessageEx(message).isOpened;
    final receivers = EcashV2MessageEx(message).receiverPubkeys
        .map((pubkey) => Account.sharedInstance.getUserInfo(pubkey))
        .where((user) => user is UserDBISAR)
        .toList()
        .cast<UserDBISAR>();
    final signees = EcashV2MessageEx(message).signees;

    var subTitle = '';
    if (isOpened) {
      subTitle = 'ecash_redeemed'.localized();
    } else if (signees.isNotEmpty && signees.any((signee) => signee.$2.isEmpty)) {
      subTitle = 'ecash_waiting_for_signature'.localized();
    } else if (receivers.isNotEmpty) {
      final userNames = receivers.abbrDesc(showUserCount: 1,);
      subTitle = 'ecash_exclusive_title'.localized({
        r'${userNames}': userNames,
      });
    }
    return Opacity(
      opacity: opacity,
      child: Container(
        // width: 240.px,
        constraints: BoxConstraints(minWidth: 240.px),
        padding: EdgeInsets.symmetric(
          horizontal: 10.px,
        ),
        margin: EdgeInsets.only(
          bottom: message.hasReactions ? 10.px : 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CommonImage(
                  iconName: 'icon_cashu_logo.png',
                  package: 'ox_chat',
                  size: Adapt.px(32),
                ).setPadding(EdgeInsets.only(right: Adapt.px(10))),
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: TextStyle(
                        color: ThemeColor.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    Visibility(
                      visible: subTitle.isNotEmpty,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          subTitle,
                          maxLines: 2,
                          style: TextStyle(
                            color: ThemeColor.white,
                            fontSize: 12.sp,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ).setPadding(EdgeInsets.symmetric(vertical: 12.5.px)),
            Container(
              color: ThemeColor.white.withOpacity(0.5),
              height: 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ecash_token_name'.localized(),
                  style: TextStyle(color: ThemeColor.white, fontSize: 12.sp),),
                CommonImage(iconName: 'icon_zaps_0xchat.png',
                  package: 'ox_chat',
                  size: 16.px,
                )
              ],
            ).setPadding(EdgeInsets.symmetric(vertical: 4.px)),
          ],
        ),
      ),
    );
  }

  static Widget _buildImageSendingMessage(
    types.CustomMessage message,
    int messageWidth,
    Widget reactionWidget,
    String? receiverPubkey,
  ) {
    final uri = ImageSendingMessageEx(message).uri;
    final url = ImageSendingMessageEx(message).url;
    final fileId = ImageSendingMessageEx(message).fileId;
    var width = ImageSendingMessageEx(message).width;
    var height = ImageSendingMessageEx(message).height;
    final encryptedKey = ImageSendingMessageEx(message).encryptedKey;
    final encryptedNonce = ImageSendingMessageEx(message).encryptedNonce;
    final stream = fileId.isEmpty || url.isNotEmpty || message.status == types.Status.error
        ? null
        : UploadManager.shared.getUploadProgress(fileId, receiverPubkey);

    if (width == null || height == null) {
      try {
        final uri = Uri.parse(url);
        final query = uri.queryParameters;
        width ??= int.tryParse(query['width'] ?? query['w'] ?? '');
        height ??= int.tryParse(query['height'] ?? query['h'] ?? '');
      } catch (_) { }
    }

    Widget widget = Hero(
      tag: message.id,
      child: ChatImagePreviewWidget(
        uri: uri,
        imageWidth: width,
        imageHeight: height,
        maxWidth: messageWidth,
        progressStream: stream,
        decryptKey: encryptedKey,
        decryptNonce: encryptedNonce,
      ),
    );

    if (message.hasReactions) {
      widget = Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.px),
              child: widget,
            ),
            reactionWidget,
          ],
        ),
      );
    }

    return widget;
  }

  static Widget _buildVideoMessage(
    types.CustomMessage message,
    int messageWidth,
    Widget reactionWidget,
    String? receiverPubkey,
    Function(types.Message newMessage)? messageUpdateCallback,
  ) {
    return ChatVideoMessage(
      message: message,
      messageWidth: messageWidth,
      reactionWidget: reactionWidget,
      receiverPubkey: receiverPubkey,
      messageUpdateCallback: messageUpdateCallback,
    );
  }
}