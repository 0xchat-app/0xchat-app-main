import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';

class ContactInfoWidget extends StatelessWidget {

  final UserDB userDB;

  const ContactInfoWidget({super.key, required this.userDB});

  @override
  Widget build(BuildContext context) {
    String _getUserName(UserDB userDB){
      return userDB.name ?? userDB.nickName ?? '';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 28.px,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _getUserName(userDB),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.px,
                    color: ThemeColor.color0,
                  ),
                ),
                SizedBox(width: 2.px,),
                DNSAuthenticationWidget(userDB: userDB,)
              ],
            ),
          ),
          DNSWidget(dns: userDB.dns ?? ''),
          SizedBox(height: 1.px,),
          EncodedPubkeyWidget(encodedPubKey: userDB.encodedPubkey,),
          SizedBox(height: 1.px,),
          BioWidget(bio: userDB.about ?? '',),
        ],
      ),
    );
  }
}


class DNSAuthenticationWidget extends StatefulWidget {
  final UserDB userDB;

  const DNSAuthenticationWidget({super.key, required this.userDB});

  @override
  State<DNSAuthenticationWidget> createState() => _DNSAuthenticationWidgetState();
}

class _DNSAuthenticationWidgetState extends State<DNSAuthenticationWidget> {

  bool _isVerifiedDNS = false;

  @override
  void initState() {
    super.initState();
    _verifiedDNS();
  }

  @override
  Widget build(BuildContext context) {
    return _isVerifiedDNS
        ? CommonImage(
            iconName: "icon_npi05_verified.png",
            width: 16.px,
            height: 16.px,
            package: 'ox_common',
          )
        : Container();
  }

  void _verifiedDNS() async {
    var isVerifiedDNS = await OXUserInfoManager.sharedInstance.checkDNS(userDB: widget.userDB);
    if (mounted) {
      setState(() {
        _isVerifiedDNS = isVerifiedDNS;
      });
    }
  }
}

class EncodedPubkeyWidget extends StatelessWidget {
  final String encodedPubKey;

  const EncodedPubkeyWidget({super.key, required this.encodedPubKey});

  @override
  Widget build(BuildContext context) {

    String newPubKey = '';
    if (encodedPubKey.isNotEmpty) {
      final String start = encodedPubKey.substring(0, 16);
      final String end = encodedPubKey.substring(encodedPubKey.length - 16);

      newPubKey = '$start:$end';
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap:() => _clickKey(encodedPubKey,context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            newPubKey,
            style: const TextStyle().defaultTextStyle(),
          ),
          SizedBox(width: 8.px),
          encodedPubKey.isNotEmpty
              ? CommonImage(
            iconName: 'icon_copy.png',
            width: 14.px,
            height: 14.px,
            useTheme: true,
          ) : Container(),
        ],
      ),
    );
  }

  Future<void> _clickKey(String keyContent,BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(
        text: keyContent,
      ),
    );
    await CommonToast.instance.show(context, 'copied_to_clipboard'.commonLocalized());
  }
}

class DNSWidget extends StatelessWidget {
  final String dns;
  const DNSWidget({super.key, required this.dns});

  @override
  Widget build(BuildContext context) {
    return dns.isNotEmpty ? Text(
      dns,
      style: const TextStyle().defaultTextStyle(),
    ) : Container();
  }
}


class BioWidget extends StatelessWidget {
  final String bio;

  const BioWidget({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return bio.isNotEmpty ? Text(
      bio,
      maxLines: 3,
      style: const TextStyle().defaultTextStyle(color: ThemeColor.color0),
    ) : Container();
  }
}

extension DefaultTextStyle on TextStyle {
  TextStyle defaultTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextOverflow? overflow,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 12.px,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? ThemeColor.color120,
      overflow: overflow ?? TextOverflow.ellipsis,
      height: height ?? 17.px / 12.px,
    );
  }
}