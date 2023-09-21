import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_relay_page.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:flutter/services.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../session/chat_secret_message_page.dart';

enum ESecretChatTime { oneHour, twelveHours, twentyFourHours, seventyTwoHours }

extension ESecretChatTimeToSecond on ESecretChatTime {
  int hour() {
    switch (this) {
      case ESecretChatTime.oneHour:
        return 1;
      case ESecretChatTime.twelveHours:
        return 12;
      case ESecretChatTime.twentyFourHours:
        return 24;
      case ESecretChatTime.seventyTwoHours:
        return 72;
    }
  }

  String toText() {
    switch (this) {
      case ESecretChatTime.oneHour:
        return '1 Hour';
      case ESecretChatTime.twelveHours:
        return '12 Hour';
      case ESecretChatTime.twentyFourHours:
        return '24 Hour';
      case ESecretChatTime.seventyTwoHours:
        return '72 Hour';
    }
  }
}

class ContactCreateSecret extends StatefulWidget {
  final UserDB userDB;

  ContactCreateSecret({Key? key, required this.userDB}) : super(key: key);
  @override
  _ContactCreateSecret createState() => new _ContactCreateSecret();
}

class _ContactCreateSecret extends State<ContactCreateSecret> {
  ESecretChatTime _keyUpdateTime = ESecretChatTime.oneHour;
  ESecretChatTime _requestValidityPeriod = ESecretChatTime.twentyFourHours;

  String _chatRelay = 'wss://relay.0xchat.com';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ThemeColor.color190, borderRadius: BorderRadius.circular(20)),
      child: SafeArea(
        child: Container(
          child: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _appBar(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(24),
            vertical: Adapt.px(12),
          ),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text(
            'SECRET CHAT SETTING',
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: Adapt.px(24),
          ),
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _labelWidget(
                title: 'Request validity period',
                content: _requestValidityPeriod.toText(),
                onTap: () => _selectTimeDialog(_selectValidityPeriodWidget),
              ),
              Container(
                height: Adapt.px(0.5),
                color: ThemeColor.color160,
              ),
              _labelWidget(
                title: 'Key update time',
                content: _keyUpdateTime.toText(),
                onTap: () => _selectTimeDialog(_selectKeyUpdateWidget),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(24),
            vertical: Adapt.px(12),
          ),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text(
            'SELECT RELAY',
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: Adapt.px(24),
          ),
          child: _labelWidget(
            title: 'Relay',
            content: _chatRelay,
            onTap: () async {
              var result = await OXNavigator.presentPage(
                context,
                (context) => ContactRelayPage(userDB: widget.userDB),
              );
              if (result != null && _isWssWithValidURL(result as String)) {
                _chatRelay = result;
                setState(() {});
              }
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: Adapt.px(12),
            horizontal: Adapt.px(24),
          ),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text(
            'For the sake of security and privacy, secret chat messages will only be sent to the relay you choose. Please select a relay you deem trustworthy.',
            style: TextStyle(
              color: ThemeColor.color100,
              fontSize: Adapt.px(12),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _labelWidget({
    required String title,
    required String content,
    required GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Adapt.px(52),
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _ellipsisText(content),
                    style: TextStyle(
                      fontSize: Adapt.px(16),
                      fontWeight: FontWeight.w400,
                      color: ThemeColor.color100,
                    ),
                  ),
                  CommonImage(
                    iconName: 'icon_arrow_more.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _ellipsisText(String text) {
    if (text.length > 30) {
      return text.substring(0, 10) +
          '...' +
          text.substring(text.length - 10, text.length);
    }
    return text;
  }

  Widget _appBar() {
    return Container(
      height: Adapt.px(56),
      padding: EdgeInsets.symmetric(
        horizontal: Adapt.px(24),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              OXNavigator.pop(context);
            },
            child: CommonImage(
              iconName: "title_close.png",
              color: Colors.white,
              width: Adapt.px(24),
              height: Adapt.px(24),
              useTheme: false,
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                Localized.text('ox_chat.create_secret_chat'),
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(17),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          GestureDetector(
            onTap: _createSecretChat,
            child: Center(
              child: CommonImage(
                iconName: 'icon_done.png',
                width: Adapt.px(24),
                height: Adapt.px(24),
                useTheme: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _createSecretChat() async {
    await OXLoading.show();
    OKEvent okEvent = await Contacts.sharedInstance.request(
      widget.userDB.pubKey,
      _chatRelay,
      expiration: _changeTimeToSecond(
        isNeedCurrentTime: true,
        hourTime: _requestValidityPeriod.hour(),
      ),
      interval: _changeTimeToSecond(hourTime: _keyUpdateTime.hour()),
    );
    await OXLoading.dismiss();
    if (okEvent.status) {
      SecretSessionDB? db =
          Contacts.sharedInstance.secretSessionMap[okEvent.eventId];
      if (db != null) {
        ChatSessionModel? chatModel =
            await OXChatBinding.sharedInstance.localCreateSecretChat(db);
        if (chatModel != null) {
          OXNavigator.pop(context);
          OXNavigator.pushReplacement(
            context,
            ChatSecretMessagePage(communityItem: chatModel),
          );
        }
      }
    } else {
      CommonToast.instance.show(context, okEvent.message);
    }
  }

  bool _isWssWithValidURL(String input) {
    RegExp regex = RegExp(
        r'^wss:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(:[0-9]{1,5})?(\/\S*)?$');
    return regex.hasMatch(input);
  }

  void _selectTimeDialog(Widget? Function(BuildContext, int) itemWidget) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Opacity(
            opacity: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: Adapt.px(215),
              decoration: BoxDecoration(
                color: ThemeColor.color180,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: itemWidget,
                        itemCount: ESecretChatTime.values.length,
                        shrinkWrap: true,
                      ),
                    ),
                    Container(
                      height: Adapt.px(8),
                      color: ThemeColor.color190,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        OXNavigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: Adapt.px(56),
                        color: ThemeColor.color180,
                        child: Center(
                          child: Text(
                            Localized.text('ox_common.cancel'),
                            style: TextStyle(
                                fontSize: 16, color: ThemeColor.color0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _selectValidityPeriodWidget(BuildContext context, int index) {
    ESecretChatTime time = ESecretChatTime.values[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _requestValidityPeriod = time;
        setState(() {});
        OXNavigator.pop(context);
      },
      child: _dialogItemWidget(time.toText(), index),
    );
  }

  Widget _selectKeyUpdateWidget(BuildContext context, int index) {
    ESecretChatTime time = ESecretChatTime.values[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _keyUpdateTime = time;
        setState(() {});
        OXNavigator.pop(context);
      },
      child: _dialogItemWidget(time.toText(), index),
    );
  }

  Widget _dividerWidget(int index) {
    return Divider(
      height: Adapt.px(0.5),
      color: ThemeColor.color160,
    );
  }

  Widget _dialogItemWidget(String name, int index) {
    return Column(
      children: [
        Container(
          height: Adapt.px(56),
          alignment: Alignment.center,
          child: Text(
            name,
            style: TextStyle(fontSize: Adapt.px(16), color: ThemeColor.color0),
          ),
        ),
        _dividerWidget(index)
      ],
    );
  }

  int _changeTimeToSecond(
      {bool isNeedCurrentTime = false, required int hourTime}) {
    int baseTime = hourTime * 60 * 60;
    if (isNeedCurrentTime) return currentUnixTimestampSeconds() * baseTime;
    return baseTime;
  }
}
