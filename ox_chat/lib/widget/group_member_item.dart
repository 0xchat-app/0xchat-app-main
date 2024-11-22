import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:path/path.dart';

class GroupMemberItem extends StatelessWidget {

  final UserDBISAR user;
  final Widget? action;
  final Color? titleColor;
  final GestureTapCallback? onTap;

  const GroupMemberItem({
    super.key,
    required this.user,
    this.action,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _buildUserItem(context,user);
  }


  Widget _buildUserItem(BuildContext context,UserDBISAR user){

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserAvatar(user.picture ?? ''),
          _buildUserInfo(context,user),
          const Spacer(),
          action ?? Container(),
        ],
      ).setPadding(EdgeInsets.only(bottom: Adapt.px(8))),
    );
  }

  Widget _buildUserAvatar(String picture) {
    Image placeholderImage = Image.asset(
      'assets/images/user_image.png',
      fit: BoxFit.cover,
      width: 40.px,
      height: 40.px,
      package: 'ox_common',
    );

    return ClipOval(
      child: Container(
        width: Adapt.px(40),
        height: Adapt.px(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(40)),
        ),
        child: OXCachedNetworkImage(
          imageUrl: picture,
          fit: BoxFit.cover,
          placeholder: (context, url) => placeholderImage,
          errorWidget: (context, url, error) => placeholderImage,
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context,UserDBISAR user) {
    String? nickName = user.nickName;
    String name = (nickName != null && nickName.isNotEmpty) ? nickName : user.name ?? '';
    String encodedPubKey = user.encodedPubkey;
    int pubKeyLength = encodedPubKey.length;
    String encodedPubKeyShow = '${encodedPubKey.substring(0, 10)}...${encodedPubKey.substring(pubKeyLength - 10, pubKeyLength)}';

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 100.px
      ),
      padding: EdgeInsets.only(
        left: Adapt.px(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: titleColor ?? ThemeColor.color0,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
