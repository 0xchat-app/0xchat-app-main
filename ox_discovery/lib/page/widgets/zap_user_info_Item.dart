import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';

class ZapUserInfoItem extends StatefulWidget {
  final UserDBISAR userDB;
  const ZapUserInfoItem({Key? key, required this.userDB}) : super(key: key);

  @override
  State<ZapUserInfoItem> createState() => _ZapUserInfoItemState();
}

class _ZapUserInfoItemState extends State<ZapUserInfoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.px, horizontal: 16.px),
      decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.circular(12.px)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserAvatar(),
          SizedBox(width: 16.px,),
          Expanded(
            child: _buildUserInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(48.px),
          child: OXCachedNetworkImage(
            imageUrl: widget.userDB.picture ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => _avatarPlaceholderImage,
            errorWidget: (context, url, error) => _avatarPlaceholderImage,
            width: 48.px,
            height: 48.px,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: FutureBuilder<BadgeDBISAR?>(
            builder: (context, snapshot) {
              return (snapshot.data != null)
                  ? OXCachedNetworkImage(
                      imageUrl: snapshot.data?.thumb ?? '',
                      placeholder: (context, url) => _badgePlaceholderImage,
                      errorWidget: (context, url, error) => _badgePlaceholderImage,
                      width: 20.px,
                      height: 20.px,
                      fit: BoxFit.cover,
                    )
                  : Container();
            },
            future: _getUserSelectedBadgeInfo(widget.userDB),
          ),
        ),
      ],
    );
  }

  String shortenString(String input) {
    if (input.length <= 24) {
      return input;
    }

    int prefixLength = 12;
    int suffixLength = 11;  // 11 + 1 (for the total of 24 characters including '...')

    String prefix = input.substring(0, prefixLength);
    String suffix = input.substring(input.length - suffixLength);

    return '$prefix...$suffix';
  }

  Widget _buildUserInfo() {
    final name = widget.userDB.name ?? widget.userDB.nickName ?? '';
    final String lnAddress = widget.userDB.lnAddress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 16.px,
            fontWeight: FontWeight.w600,
            color: ThemeColor.color0,
          ),
        ),
        Text(
          shortenString(lnAddress),
          maxLines: 1,
          style: TextStyle(
            fontSize: 14.px,
            fontWeight: FontWeight.w400,
            color: ThemeColor.color120,
          ),
        ),
      ],
    );
  }

  final Widget _badgePlaceholderImage = CommonImage(
    iconName: 'icon_badge_default.png',
    fit: BoxFit.cover,
    width: 20.px,
    height: 20.px,
    useTheme: true,
  );

  final Image _avatarPlaceholderImage = Image.asset(
    'assets/images/icon_user_default.png',
    fit: BoxFit.contain,
    width: 48.px,
    height: 48.px,
    package: 'ox_common',
  );

  Future<BadgeDBISAR?> _getUserSelectedBadgeInfo(UserDBISAR friendDB) async {
    UserDBISAR? friendUserDB = await Account.sharedInstance.getUserInfo(friendDB.pubKey);
    if (friendUserDB == null) {
      return null;
    }
    String badges = friendUserDB.badges ?? '';
    if (badges.isNotEmpty) {
      List<dynamic> badgeListDynamic = jsonDecode(badges);
      List<String> badgeList = badgeListDynamic.cast();
      BadgeDBISAR? badgeDB;
      try {
        List<BadgeDBISAR?> badgeDBList =
        await BadgesHelper.getBadgeInfosFromDB(badgeList);
        badgeDB = badgeDBList.first;
      } catch (error) {
        LogUtil.e("user selected badge info fetch failed: $error");
      }
      return badgeDB;
    }
    return null;
  }
}
