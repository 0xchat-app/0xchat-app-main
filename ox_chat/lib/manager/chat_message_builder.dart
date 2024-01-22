
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
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

  static Widget buildCustomMessage(types.CustomMessage message, { required int messageWidth }) {

    final isMe = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey == message.author.id;
    final type = message.customType;

    switch (type) {
      case CustomMessageType.zaps:
        return _buildZapsMessage(message);
      case CustomMessageType.call:
        return _buildCallMessage(message, isMe);
      case CustomMessageType.template:
        return _buildTemplateMessage(message, isMe);
      case CustomMessageType.note:
        return _buildNoteMessage(message, isMe);
      case CustomMessageType.ecash:
        return _buildEcashMessage(message, isMe);
      default:
        return SizedBox();
    }
  }

  static Widget _buildZapsMessage(types.CustomMessage message) {
    final amount = ZapsMessageEx(message).amount.formatWithCommas();
    final description = ZapsMessageEx(message).description;
    return Container(
      width: Adapt.px(240),
      height: Adapt.px(86),
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
      child: Column(
        children: [
          Expanded(child: Row(
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
                Text(Localized.text('ox_chat.lightning_invoice'),
                  style: TextStyle(color: ThemeColor.white, fontSize: 12),),
                CommonImage(iconName: 'icon_zaps_0xchat.png',
                  package: 'ox_chat',
                  size: Adapt.px(16),)
              ],
            ),
          )
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(10))),
    );
  }

  static Widget _buildCallMessage(types.CustomMessage message, bool isMe) {
    final text = CallMessageEx(message).callText;
    final type = CallMessageEx(message).callType;
    final tintColor = isMe ? ThemeColor.white : ThemeColor.color0;
    return Container(
      padding: EdgeInsets.all(Adapt.px(10)),
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

  static Widget _buildTemplateMessage(types.CustomMessage message, bool isMe) {
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
      padding: EdgeInsets.all(10.px),
      color: ThemeColor.color180,
      child: Column(
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

  static Widget _buildNoteMessage(types.CustomMessage message, bool isMe) {
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
        ],
      ),
    );
  }

  static Widget _buildEcashMessage(types.CustomMessage message, bool isMe) {
    final description = EcashMessageEx(message).description;
    final isOpened = true ;EcashMessageEx(message).isOpened;

    return Opacity(
      opacity: isOpened ? 0.5 : 1,
      child: Container(
        width: Adapt.px(240),
        height: Adapt.px(86),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.centerLeft,
        //     end: Alignment.centerRight,
        //     colors: [
        //       ThemeColor.gradientMainEnd.withOpacity(0.5),
        //       ThemeColor.gradientMainStart.withOpacity(0.5),
        //     ],
        //   ),
        // ),
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
                      ),
                    ),
                    Visibility(
                      visible: isOpened,
                      child: Text(
                        'Opened',
                        style: TextStyle(
                          color: ThemeColor.white,
                          fontSize: 12.sp,
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
                  Text('Cashu Token',
                    style: TextStyle(color: ThemeColor.white, fontSize: 12),),
                  CommonImage(iconName: 'icon_zaps_0xchat.png',
                    package: 'ox_chat',
                    size: Adapt.px(16),)
                ],
              ),
            )
          ],
        ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(10))),
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