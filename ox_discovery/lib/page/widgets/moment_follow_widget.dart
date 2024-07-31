import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

class MomentFollowWidget extends StatefulWidget {
  final UserDBISAR userDB;
  const MomentFollowWidget({super.key, required this.userDB});

  @override
  State<MomentFollowWidget> createState() => _MomentFollowWidgetState();
}

class _MomentFollowWidgetState extends State<MomentFollowWidget> {

  bool? _isContact;
  String get pubKey => widget.userDB.pubKey;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    bool result = Contacts.sharedInstance.allContacts.containsKey(pubKey);
    _updateStatus(result);
  }

  void _updateStatus(bool status){
    setState(() {
      _isContact = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isContact != null
        ? Row(
            children: [
              if (!_isContact!) ...[
                CommonImage(
                  iconName: 'icon_moment_follow.png',
                  size: 24.px,
                  package: 'ox_discovery',
                  useTheme: true,
                ),
                SizedBox(width: 4.px,)],
              _buildButton(title: _isContact! ? Localized.text('ox_discovery.unfollow') : Localized.text('ox_discovery.follow')),
            ],
          )
        : Container();
  }

  Widget _buildButton({required String title}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _isContact! ? _removeFollows : _addFollows,
      child: Container(
        width: 96.px,
        height: 24.px,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.px),
            border: Border.all(
                width: 0.5.px,
                color: ThemeColor.color100,
            )
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.px,
              color: ThemeColor.color0
          ),
        ),
      ),
    );
  }

  _addFollows() async {
    OXLoading.show();
    OKEvent event = await Contacts.sharedInstance.addToContact([pubKey]);
    OXLoading.dismiss();
    if(event.status) {
      _updateStatus(true);
      CommonToast.instance.show(context, Localized.text('ox_discovery.follow_success_tips'));
    }
  }

  _removeFollows() async {
    OXLoading.show();
    OKEvent event = await Contacts.sharedInstance.removeContact(pubKey);
    OXLoading.dismiss();
    if(event.status) {
      _updateStatus(false);
      CommonToast.instance.show(context, Localized.text('ox_discovery.unfollow_success_tips'));
    }
  }
}
