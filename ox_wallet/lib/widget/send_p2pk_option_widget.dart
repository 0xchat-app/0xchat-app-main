
import 'package:flutter/material.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:chatcore/chat-core.dart';
import 'package:intl/intl.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_action_dialog.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/list_extension.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_theme/ox_theme.dart';

class SendP2PKOption {
  List<UserDB> singer = [];
  P2PKSecretSigFlag? sigFlag;
  int? sigNum;
  DateTime? lockTime;
  List<UserDB> refund = [];

  bool enable = false;
}

extension SendP2PKOptionUIEx on SendP2PKOption {
  String get signerDesc => singer.abbrDesc(
    noneText: Localized.text('ox_common.none'),
    showUserCount: 1,
    userNameBuilder: (user) => user.shortEncodedPubkey,
  );

  String get sigFlagDesc {
    final sigText = sigFlag?.value ?? '';
    var text = Localized.text('ox_common.none');
    if (sigText.isNotEmpty) {
      text = sigText;
    }
    return text;
  }

  String get sigNumDesc => sigNum != null ? '$sigNum' : Localized.text('ox_common.none');

  String get lockTimeDesc {
    var text = Localized.text('ox_common.none');
    if (lockTime != null) {
      final DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm:ss');
      text = formatter.format(lockTime!);
    }
    return text;
  }

  String get refundDesc => refund.abbrDesc(
    noneText: Localized.text('ox_common.none'),
    showUserCount: 1,
    userNameBuilder: (user) => user.shortEncodedPubkey,
  );
}

class SendP2PKOptionWidget extends StatefulWidget {
  const SendP2PKOptionWidget({
    super.key,
    required this.option,
  });

  final SendP2PKOption option;

  @override
  State<StatefulWidget> createState() => SendP2PKOptionWidgetState();
}

class SendP2PKOptionWidgetState extends State<SendP2PKOptionWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        if (widget.option.enable)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.px),
              color: ThemeColor.color180,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildP2PKPubkeyTag(),
                _buildP2PKSigFlagTag(),
                _buildP2PKSigNumTag(),
                _buildP2PKLockTimeTag(),
                _buildP2PKRefundTag(),
              ].insertEveryN(1, const Divider(height: 1,)),
            ),
          ).setPaddingOnly(top: 24.px),
      ],
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => setState(() {
        widget.option.enable = !widget.option.enable;
      }),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.option.enable ?
              CommonImage(
                iconName: 'icon_theme_selected.png',
                size: 20.px,
              ) :
              CommonImage(
                iconName: 'icon_item_unselected.png',
                size: 20.px,
                package: 'ox_wallet',
                useTheme: true,
              ),
            Text(
              'P2PK',
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeColor.color0,
                fontWeight: FontWeight.bold,
              ),
            ).setPadding(EdgeInsets.symmetric(horizontal: 8.px)),
          ],
        ),
      ),
    );
  }

  Widget _buildP2PKPubkeyTag() {
    return _buildItem('Pubkey', widget.option.signerDesc, () async {
      final pubkeyUser = await OXChatInterface.pushUserSelectionPage(
        context: context,
        defaultSelected: widget.option.singer,
        additionalUserList: [OXUserInfoManager.sharedInstance.currentUserInfo!],
        isMultiSelect: true,
        allowFetchUserFromRelay: true,
      );
      if (pubkeyUser != null) {
        setState(() {
          widget.option.singer = pubkeyUser;
        });
      }
    });
  }

  Widget _buildP2PKSigFlagTag() {
    return _buildItem('SigFlags', widget.option.sigFlagDesc, () async {
      final result = await OXActionDialog.show(
        context,
        data: [
          OXActionModel(identify: null, text: Localized.text('ox_common.none')),
          OXActionModel(identify: P2PKSecretSigFlag.inputs, text: P2PKSecretSigFlag.inputs.value),
          OXActionModel(identify: P2PKSecretSigFlag.all, text: P2PKSecretSigFlag.all.value),
        ],
      );
      if (result != null) {
        setState(() {
          widget.option.sigFlag = result.identify;
        });
      }
    });
  }

  Widget _buildP2PKSigNumTag() {
    return _buildItem('N_sig', widget.option.sigNumDesc, () async {
      final text = await OXCommonHintDialog.showInputDialog(
        context,
        title: 'Input N_sigs numbers',
        maxLength: 2,
        keyboardType: TextInputType.number,
        defaultText: widget.option.sigNum?.toString(),
      );
      if (text != null) {
        setState(() {
          widget.option.sigNum = int.tryParse(text);
        });
      }
    });
  }

  Widget _buildP2PKLockTimeTag() {
    return _buildItem('LockTime', widget.option.lockTimeDesc, () async {
      widget.option.lockTime = await selectLockTime(widget.option.lockTime);
      setState(() { });
    });
  }

  Widget _buildP2PKRefundTag() {
    return _buildItem('Refund', widget.option.refundDesc, () async {
      final refundUser = await OXChatInterface.pushUserSelectionPage(
        context: context,
        defaultSelected: widget.option.refund,
        additionalUserList: [OXUserInfoManager.sharedInstance.currentUserInfo!],
        isMultiSelect: true,
        allowFetchUserFromRelay: true,
      );
      if (refundUser != null) {
        setState(() {
          widget.option.refund = refundUser;
        });
      }
    });
  }

  Widget _buildItem(String title, String value, GestureTapCallback onTap) {
    final space = 16.px;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        height: 52.px,
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: ThemeColor.color0,
              ),
            ).setPaddingOnly(right: space),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeColor.color100,
              ),
            ),
            CommonImage(
              iconName: 'icon_wallet_more_arrow.png',
              size: 24.px,
              package: 'ox_wallet',
            ),
          ],
        ).setPadding(EdgeInsets.symmetric(horizontal: space)),
      ),
    );
  }

  Future<DateTime?> selectLockTime(DateTime? defaultDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: defaultDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      cancelText: Localized.text('ox_common.cancel'),
      confirmText: Localized.text('ox_common.next_step'),
      builder: (_, child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            brightness: ThemeManager.brightness(),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
    if (date == null || !context.mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: defaultDate != null ? TimeOfDay.fromDateTime(defaultDate) : TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
      cancelText: 'Previous',
      builder: (_, child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            brightness: ThemeManager.brightness(),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
    if (time == null) {
      return selectLockTime(DateTime(
        date.year,
        date.month,
        date.day,
        defaultDate?.hour ?? TimeOfDay.now().hour,
        defaultDate?.minute ?? TimeOfDay.now().minute,
        0,
      ));
    }

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      0,
    );
  }
}