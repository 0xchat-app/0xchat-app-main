import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import '../enum/moment_enum.dart';
import 'package:intl/intl.dart';
class MomentOption {
  GestureTapCallback? onTap;
  EMomentOptionType type;
  int? clickNum;

  MomentOption({
    this.onTap,
    this.clickNum,
    required this.type,
  });
}

List<MomentOption> showMomentOptionData = [
  MomentOption(
    type: EMomentOptionType.reply,
    clickNum: 0,
  ),
  MomentOption(
    type: EMomentOptionType.repost,
    clickNum: 200,
  ),
  MomentOption(
    type: EMomentOptionType.like,
    clickNum: 3100,
  ),
  MomentOption(
    type: EMomentOptionType.zaps,
    clickNum: 12200,
  ),
];
