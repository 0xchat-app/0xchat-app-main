import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/page/set_up/privacy_blocked_page.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {

  List<String> _blockList = [];

  List<UserDB> _blockBlockedUser = [];

  @override
  void initState() {
    super.initState();
    _getBlockedUserPubkeys();
    if(_blockList.isNotEmpty){
      _getBlockUserProfile(_blockList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Localized.text('ox_usercenter.privacy'),
        centerTitle: true,
        useLargeTitle: false,
      ),
      backgroundColor: ThemeColor.color190,
      body: _buildBody().setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24),vertical: Adapt.px(12))),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildItem(
          leading: CommonImage(
            iconName: 'icon_privacy_block.png',
            width: Adapt.px(32),
            height: Adapt.px(32),
            package: 'ox_usercenter',
          ),
          content: Localized.text('ox_usercenter.blocked_users_title'),
          actions: Row(
            children: [
              Text(
                _blockList.length.toString(),
                style: TextStyle(
                    fontSize: Adapt.px(16),
                    fontWeight: FontWeight.w400,
                    color: ThemeColor.color100),
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
    );
  }

  Widget _buildItem({String? content, Widget? leading, Widget? actions, Color? contentColor}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Adapt.px(12), horizontal: Adapt.px(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          OXNavigator.pushPage(context, (context) => PrivacyBlockedPage(blockedUsers: _blockBlockedUser,)).then((value){
            if(value != null){
              _getBlockedUserPubkeys();
              _getBlockUserProfile(_blockList);
            }
          });
        },
        child: Row(children: [
          leading ?? Container(),
          SizedBox(width: Adapt.px(12),),
          Expanded(
            child: Text(
              content ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w400,
                color: contentColor ?? ThemeColor.color0,
                height: Adapt.px(22) / Adapt.px(16),
              ),
            ),
          ),
          actions ?? Container()
        ]),
      ),
    );
  }

  void _getBlockedUserPubkeys(){
    List<String>?  blockResult = Contacts.sharedInstance.blockList;
    if(blockResult != null){
      setState(() {
        _blockList = blockResult;
      });
    }
  }

  Future<void> _getBlockUserProfile(List<String> pubKeys) async {
    Map<String, UserDB> result = await Account.sharedInstance.getUserInfos(pubKeys);
    _blockBlockedUser = result.values.toList();
  }
}
