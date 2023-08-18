
import 'package:flutter/material.dart';
import 'package:ox_chat/widget/radio_list_tile.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'dart:ui';

abstract class ReportTarget {
  Future<String> reportAction(String reason);
}

class ReportDialog extends StatefulWidget {

  ReportDialog(this.target);

  final ReportTarget target;

  @override
  State<StatefulWidget> createState() => ReportDialogState();

  static Future<bool?> show(BuildContext context, {required ReportTarget target}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => ReportDialog(target),
    );
  }
}

class ReportDialogState extends State<ReportDialog> {

  List<OXRadioListTileItemModel> modelList = [
    Localized.text('ox_chat.report_reason_spam'),
    Localized.text('ox_chat.report_reason_violence'),
    Localized.text('ox_chat.report_reason_child_abuse'),
    Localized.text('ox_chat.report_reason_pornography'),
    Localized.text('ox_chat.report_reason_copyright'),
    Localized.text('ox_chat.report_reason_illegal_drugs'),
    Localized.text('ox_chat.report_reason_personal_details'),
  ].map((title) => OXRadioListTileItemModel(title: title)).toList();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top,
        color: ThemeColor.color190,
        child: Column(
          children: <Widget>[
            CommonAppBar(
              useLargeTitle: false,
              centerTitle: true,
              title: Localized.text('ox_chat.message_menu_report'),
              titleTextColor: ThemeColor.color0,
              actions: [
                //icon_edit.png
                Container(
                  margin: EdgeInsets.only(
                    right: Adapt.px(20),
                  ),
                  color: Colors.transparent,
                  child: _buildDoneButton(context),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
              child: Padding(
                padding: EdgeInsets.only(top: Adapt.px(12)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Localized.text('ox_chat.report_reason_title'),
                      style: TextStyle(color: ThemeColor.titleColor, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Adapt.px(15)),
                      child: OXRadioListTile(
                        modelList: modelList,
                        onSelected: (model) {
                          setState(() { });
                          return true;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    var isEnable = false;
    modelList.forEach((model) {
      if (model.isSelected) {
        isEnable = true;
      }
    });
    return OXButton(
      color: Colors.transparent,
      minWidth: Adapt.px(44),
      height: Adapt.px(44),
      child: CommonImage(
        iconName: 'icon_done.png',
        color: isEnable ? null : ThemeColor.color160,
        width: Adapt.px(24),
        height: Adapt.px(24),
      ),
      onPressed: isEnable ? () => _doneButtonPressHandler(context) : null,
    );
  }

  void _doneButtonPressHandler(BuildContext context) async {
    var selectedModels = modelList.where((model) => model.isSelected);
    if (selectedModels.length > 0) {
      OXLoading.show();
      final failMessage = await widget.target.reportAction(selectedModels.first.title);
      OXLoading.dismiss();
      if (failMessage.isEmpty) {
        OXNavigator.pop(context, true);
      } else {
        CommonToast.instance.show(context, failMessage);
      }
    }
  }
}