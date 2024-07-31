import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_network_image.dart';

class ContactItem<T> extends StatelessWidget {
  final T contact;
  final Widget? action;
  final Color? titleColor;
  final GestureTapCallback? onTap;
  const ContactItem({super.key, required this.contact, this.action, this.titleColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return _buildContactItem(contact);
  }

  Widget _buildContactItem(T contact){
    final picture = contact is UserDBISAR ? contact.picture ?? '' : (contact as GroupDB).picture ?? '';
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(picture),
          _buildInfo(contact),
          const Spacer(),
          action ?? Container(),
        ],
      ).setPadding(EdgeInsets.only(bottom: Adapt.px(8))),
    );
  }

  Widget _buildAvatar(String picture) {
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
        child: OXCachedNetworkImage(
          imageUrl: picture,
          fit: BoxFit.cover,
          placeholder: (context, url) => placeholderImage,
          errorWidget: (context, url, error) => placeholderImage,
        ),
      ),
    );
  }

  Widget _buildInfo(T contact) {
    final encodedPubKey = _getEncodedPubKey(contact);
    return Container(
      padding: EdgeInsets.only(
        left: Adapt.px(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getContactName(contact),
            style: TextStyle(
              color: titleColor ?? ThemeColor.color0,
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          encodedPubKey != null ? Text(
            encodedPubKey,
            style: TextStyle(
              color: ThemeColor.color120,
              fontSize: Adapt.px(14),
              fontWeight: FontWeight.w400,
            ),
          ) : Container(),
        ],
      ),
    );
  }

  String _getContactName(T contact){
    if(contact is UserDBISAR){
      String? nickName = contact.nickName;
      return (nickName != null && nickName.isNotEmpty) ? nickName : contact.name ?? '';
    }
    if(contact is GroupDB) return contact.name;
    return '';
  }

  String? _getEncodedPubKey(T contact){
    if(contact is UserDBISAR){
      String encodedPubKey = contact.encodedPubkey;
      int pubKeyLength = encodedPubKey.length;
      return '${encodedPubKey.substring(0, 10)}...${encodedPubKey.substring(pubKeyLength - 10, pubKeyLength)}';
    }
    return null;
  }

  String _getPicture(T contact){
    return contact is UserDBISAR ? contact.picture ?? '' : (contact as GroupDB).picture ?? '';
  }
}
