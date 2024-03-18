import 'package:flutter/cupertino.dart';
import '../enum/moment_enum.dart';

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
    onTap: () {
      print('EMomentOptionType.reply');
    },
    type: EMomentOptionType.reply,
    clickNum: 100,
  ),
  MomentOption(
    onTap: () {
      print('EMomentOptionType.repost');
    },
    type: EMomentOptionType.repost,
    clickNum: 200,
  ),
  MomentOption(
    onTap: () {
      print('EMomentOptionType.like');
    },
    type: EMomentOptionType.like,
    clickNum: 3100,
  ),
  MomentOption(
    onTap: () {
      print('EMomentOptionType.zaps');
    },
    type: EMomentOptionType.zaps,
    clickNum: 12200,
  ),
];
