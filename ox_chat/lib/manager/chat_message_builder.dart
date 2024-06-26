
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/ecash_helper.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/num_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ChatMessageBuilder {

  static Widget buildRepliedMessageView(types.Message message,
      {required int messageWidth}) {
    final repliedMessage = message.repliedMessage;
    if (repliedMessage == null) return SizedBox();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: messageWidth.toDouble(),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(12)),
          color: ThemeColor.color190,
        ),
        margin: EdgeInsets.only(top: Adapt.px(2)),
        padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(12), vertical: Adapt.px(4)),
        child: Text(
          repliedMessage.replyDisplayContent,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: ThemeColor.color120,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  static Widget buildReactionsView(types.Message message,
      {required int messageWidth}) {
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
              children: reactions.map((reaction) => _buildReactionItem(reaction)).toList(),
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

  static Widget _buildReactionItem(types.Reaction reaction) {
    const maxAuthorCount = 3;
    var reactionNames = <String>[];
    var reactionNamesLength = 0;
    var reactionNamesSuffix = '';
    bool isOverCount = false;
    for (final pubkey in reaction.authors) {
      final user = Account.sharedInstance.getUserInfo(pubkey);
      if (user is UserDB) {
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

    return Container(
      height: 18.px,
      padding: EdgeInsets.symmetric(horizontal: 6.px),
      decoration: BoxDecoration(
        color: ThemeColor.darkColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(9.px),
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
    );
  }

  static Widget _buildZapsItem(types.ZapsInfo zapsInfo) {
    final text = '${zapsInfo.author.getUserShowName()} zaps ${zapsInfo.amount} ${zapsInfo.unit}';
    return Container(
      height: 18.px,
      padding: EdgeInsets.symmetric(horizontal: 6.px),
      decoration: BoxDecoration(
        color: ThemeColor.darkColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(9.px),
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

  static Widget buildCustomMessage({
    required types.CustomMessage message,
    required int messageWidth,
    required Widget reactionWidget,
  }) {
    final isMe = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey == message.author.id;
    final type = message.customType;

    switch (type) {
      case CustomMessageType.zaps:
        return _buildZapsMessage(message);
      case CustomMessageType.call:
        return _buildCallMessage(message, isMe);
      case CustomMessageType.template:
        return _buildTemplateMessage(message, reactionWidget, isMe);
      case CustomMessageType.note:
        return _buildNoteMessage(message, reactionWidget, isMe);
      case CustomMessageType.ecash:
        return _buildEcashMessage(message, reactionWidget, isMe);
      case CustomMessageType.ecashV2:
        return _buildEcashV2Message(message, reactionWidget);
      default:
        return SizedBox();
    }
  }

  static Widget _buildZapsMessage(types.CustomMessage message) {
    final amount = ZapsMessageEx(message).amount.formatWithCommas();
    final description = ZapsMessageEx(message).description;
    return Container(
      width: 240.px,
      height: 86.px,
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
          )
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ThemeColor.color0,
                    height: 1.4
                  ),
                  textAlign: TextAlign.center,
                ).setPadding(EdgeInsets.only(right: 4.px)),
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
        .where((user) => user is UserDB)
        .toList()
        .cast<UserDB>();
    final signees = EcashV2MessageEx(message).signees;

    var subTitle = '';
    if (isOpened) {
      subTitle = 'ecash_redeemed'.localized();
    } else if (signees.isNotEmpty && signees.any((signee) => signee.$2.isEmpty)) {
      subTitle = 'ecash_waiting_for_signature'.localized();
    } else if (receivers.isNotEmpty) {
      final userNames = EcashHelper.userListText(receivers, showUserCount: 1,);
      subTitle = 'ecash_exclusive_title'.localized({
        r'${userNames}': userNames,
      });
    }
    return Opacity(
      opacity: opacity,
      child: Container(
        height: 86.px,
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
            Expanded(
              child: Row(
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
                  Text('ecash_token_name'.localized(),
                    style: TextStyle(color: ThemeColor.white, fontSize: 12),),
                  CommonImage(iconName: 'icon_zaps_0xchat.png',
                    package: 'ox_chat',
                    size: Adapt.px(16),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension CallMessageTypeEx on CallMessageType {
  String get iconName {
    switch (this) {
      case CallMessageType.audio:
        return 'icon_message_call.png';
      case CallMessageType.video:
        return 'icon_message_camera.png';
      default:
        return '';
    }
  }
}