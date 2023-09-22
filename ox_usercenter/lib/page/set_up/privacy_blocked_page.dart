import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

class PrivacyBlockedPage extends StatefulWidget {

  final List<UserDB> blockedUsers;

  const PrivacyBlockedPage({super.key,required this.blockedUsers});

  @override
  State<PrivacyBlockedPage> createState() => _PrivacyBlockedPageState();
}

class _PrivacyBlockedPageState extends State<PrivacyBlockedPage> with CommonStateViewMixin{

  final List<UserDB> _selectedUserList = [];

  bool _isEdit = false;

  late bool _isShowEdit;

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
        break;
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  @override
  void initState() {
    _isShowEdit = true;
    if(widget.blockedUsers.isEmpty){
      _isShowEdit = false;
      updateStateView(CommonStateView.CommonStateView_NoData);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_usercenter.blocked'),
        backgroundColor: ThemeColor.color190,
        actions: [
          _isShowEdit ? _buildEditButton() : Container(),
        ],
      ),
      body: commonStateViewWidget(context,_buildBody(),errorTip: Localized.text('ox_usercenter.no_blocked_user')),
    );
  }

  Widget _buildEditButton(){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if(!_isEdit){
          _selectedUserList.clear();
        }
        setState(() {
          _isEdit = !_isEdit;
        });
      },
      child: Center(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                ThemeColor.gradientMainEnd,
                ThemeColor.gradientMainStart,
              ],
            ).createShader(Offset.zero & bounds.size);
          },
          child: Text(
            _isEdit ? 'Done' : 'Edit',
            style: TextStyle(
              fontSize: Adapt.px(16),
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ).setPadding(EdgeInsets.only(right: Adapt.px(24))),
    );
  }

  Widget _buildBody() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(24),vertical: Adapt.px(12)),
          child: ListView.builder(
            itemCount: widget.blockedUsers.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildBlockedUserItem(widget.blockedUsers[index],index);
            },
          ),
        ),
        _isEdit && _selectedUserList.isNotEmpty
            ? Positioned(
                left: 0,
                right: 0,
                bottom: Adapt.px(bottomPadding > 0 ? bottomPadding : 0),
                child: _buildRemoveButton(),
              )
            : Container(),
      ],
    );
  }

  Widget _buildBlockedUserItem(UserDB blockedUser,int index){

    bool isSelected = _selectedUserList.contains(widget.blockedUsers[index]);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        if(_isEdit){
          if(!_selectedUserList.contains(widget.blockedUsers[index])){
            _selectedUserList.add(widget.blockedUsers[index]);
          }else{
            _selectedUserList.remove(widget.blockedUsers[index]);
          }
          setState(() {
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserAvatar(blockedUser.picture ?? ''),
          _buildUserInfo(blockedUser),
          const Spacer(),
          _isEdit ? CommonImage(
            width: Adapt.px(24),
            height:  Adapt.px(24),
            iconName: isSelected ? 'icon_select_follows.png' : 'icon_unSelect_follows.png',
            package: 'ox_chat',
          ): Container(),
        ],
      ).setPadding(EdgeInsets.only(bottom: Adapt.px(8))),
    );
  }

  Widget _buildUserAvatar(String picture) {
    Image placeholderImage = Image.asset(
      'assets/images/user_image.png',
      fit: BoxFit.cover,
      width: Adapt.px(76),
      height: Adapt.px(76),
      package: 'ox_common',
    );

    return ClipOval(
      child: Container(
        width: Adapt.px(40),
        height: Adapt.px(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(40)),
        ),
        child: CachedNetworkImage(
          imageUrl: picture,
          fit: BoxFit.cover,
          placeholder: (context, url) => placeholderImage,
          errorWidget: (context, url, error) => placeholderImage,
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserDB userInfo) {
    String? nickName = userInfo.nickName;
    String name = (nickName != null && nickName.isNotEmpty) ? nickName : userInfo.name ?? '';
    String encodedPubKey = userInfo.encodedPubkey;
    int pubKeyLength = encodedPubKey.length;
    String encodedPubKeyShow = '${encodedPubKey.substring(0, 10)}...${encodedPubKey.substring(pubKeyLength - 10, pubKeyLength)}';

    return Container(
      padding: EdgeInsets.only(
        left: Adapt.px(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            encodedPubKeyShow,
            style: TextStyle(
              color: ThemeColor.color120,
              fontSize: Adapt.px(14),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await _removeBlockList(_selectedUserList);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Adapt.px(24),
          vertical: Adapt.px(16),
        ),
        width: double.infinity,
        height: Adapt.px(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ThemeColor.color180,
          gradient: LinearGradient(
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          'Remove ${_selectedUserList.length} users ',
          style: TextStyle(
            color: Colors.white,
            fontSize: Adapt.px(14),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Future<void> _removeBlockList(List<UserDB> blockUsers) async {
    List<String> blockPubKeys = blockUsers.map((item) => item.pubKey).toList();
    await OXLoading.show();
    try{
      OKEvent okEvent = await Contacts.sharedInstance.removeBlockList(blockPubKeys);
      await OXLoading.dismiss();
      if(okEvent.status) {
        CommonToast.instance.show(context, 'Unblock successful');
        OXNavigator.pop(context,true);
      } else {
        CommonToast.instance.show(context, 'Unblock failed, please try again later.');
      }
    }catch(e,s){
      CommonToast.instance.show(context, 'Unblock failed, please try again later.');
      await OXLoading.dismiss();
      LogUtil.e('Unblock failed: $e\r\n$s');
    }
  }
}
