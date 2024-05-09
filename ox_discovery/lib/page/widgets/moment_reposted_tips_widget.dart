import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_module_service/ox_module_service.dart';

class MomentRepostedTips extends StatefulWidget {
  final NoteDB noteDB;
  const MomentRepostedTips({
    super.key,
    required this.noteDB,
  });

  @override
  _MomentRepostedTipsState createState() => _MomentRepostedTipsState();
}

class _MomentRepostedTipsState extends State<MomentRepostedTips> {
  UserDB? momentUserDB;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMomentUser();
  }

  void _getMomentUser() async {
    UserDB? user = await Account.sharedInstance.getUserInfo(widget.noteDB.author);
    momentUserDB = user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String? repostId = widget.noteDB.repostId;
    if (repostId == null || repostId.isEmpty) return const SizedBox();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonImage(
          iconName: 'repost_moment_icon.png',
          size: 16.px,
          package: 'ox_discovery',
          color: ThemeColor.color100,
        ).setPaddingOnly(
          right: 8.px,
        ),
        GestureDetector(
          onTap: () {
            OXModuleService.pushPage(
                context, 'ox_chat', 'ContactUserInfoPage', {
              'pubkey': momentUserDB?.pubKey,
            });
          },
          child: Text(
            '${momentUserDB?.name ?? ''} ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.px,
              color: ThemeColor.color100,
            ),
          ),
        ),
        Text(
          'Reposted',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.px,
            color: ThemeColor.color100,
          ),
        )
      ],
    ).setPaddingOnly(bottom: 4.px);
  }
}

