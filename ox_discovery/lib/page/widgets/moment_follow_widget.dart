import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';

class MomentFollowWidget extends StatefulWidget {
  final UserDB userDB;
  const MomentFollowWidget({super.key, required this.userDB});

  @override
  State<MomentFollowWidget> createState() => _MomentFollowWidgetState();
}

class _MomentFollowWidgetState extends State<MomentFollowWidget> {

  bool? _isFollow;
  String get pubKey => widget.userDB.pubKey;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    bool result = await Account.sharedInstance.onFollowingList(pubKey);
    _updateStatus(result);
  }

  void _updateStatus(bool status){
    setState(() {
      _isFollow = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isFollow != null
        ? Row(
            children: [
              if (!_isFollow!) ...[
                CommonImage(
                  iconName: 'icon_moment_follow.png',
                  size: 24.px,
                  package: 'ox_discovery',
                ),
                SizedBox(width: 4.px,)],
              _buildButton(title: _isFollow! ? 'Remove' : 'Add Follow'),
            ],
          )
        : Container();
  }

  Widget _buildButton({required String title}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _isFollow! ? _removeFollows : _addFollows,
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
    OKEvent event = await Account.sharedInstance.addFollows([pubKey]);
    OXLoading.dismiss();
    if(event.status) {
      _updateStatus(true);
      CommonToast.instance.show(context, 'Add follow successful');
    }
  }

  _removeFollows() async {
    OXLoading.show();
    OKEvent event = await Account.sharedInstance.removeFollows([pubKey]);
    OXLoading.dismiss();
    if(event.status) {
      _updateStatus(false);
      CommonToast.instance.show(context, 'Remove follow successful');
    }
  }
}
