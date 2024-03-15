import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_push/src/unifiedpush.dart';
import 'package:ox_push/src/constants.dart';

///Title: push_picker_dialogs
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/3/15 15:45
class PushPickerDialog extends StatelessWidget {
  final List<String> distributors;
  PushPickerDialog({Key? key, required this.distributors}): super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.px),
        color: ThemeColor.color180,
      ),
      height: (56.5 * distributors.length + 8 +  56 + 36).px,
      child: ListView(
        children: [
          Container(
            height: 36.px,
            alignment: Alignment.center,
            child: Text(
              Localized.text('ox_common.str_select_push_app_title'),
              style: TextStyle(
                color: ThemeColor.color100,
                fontSize: 14.px,
              ),
            ),
          ),
          for (var d in distributors)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: 56.5.px,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 0.5.px,
                      alignment: Alignment.topCenter,
                      color: ThemeColor.color160,
                    ),
                    SizedBox(
                      height: 56.px,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(getShowTitle(d), style: TextStyle(color: ThemeColor.color0, fontSize: 16.px)),
                          ),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: Text(getShowContent(d), style: TextStyle(color: ThemeColor.color10, fontSize: 12.px)),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context, d);
              },
            ),
          Container(
            height: 8.px,
            color: ThemeColor.color200,
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: 56.px,
              child: Text(
                Localized.text('ox_common.cancel'),
                style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w400),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

noDistributorDialog({required Null Function() onDismissed}) {
  return (BuildContext context) {
    return AlertDialog(
      title: const Text('Push Notifications'),
      content: const SingleChildScrollView(
          child: SelectableText(
              "You need to install a distributor for push notifications to work.\nYou can find more information at: https://unifiedpush.org/users/intro/")),
      actions: [
        TextButton(
          child: const Text('Dismiss'),
          onPressed: () {
            onDismissed();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Close'),
          onPressed: Navigator.of(context).pop,
        ),
      ],
    );
  };
}

String getShowTitle(String distributor){
  LogUtil.e('John: --getShowTitle--------distributor =${distributor}');
  switch (distributor){
    case ppnNtfy:
      return 'ntfy';
    case ppnNextPush:
      return 'NextPush';
    case ppnConversations:
      return 'Conversations';
    case ppnOxchat:
      return 'FOSS-FCM';
    default:
      return Localized.text('ox_common.none');
  }
}

String getShowContent(String distributor){
  if (distributor == UnifiedPush.noDistribAck){
    return Localized.text('ox_common.str_disables_push_notification');
  } else {
    return Localized.text('ox_common.str_uses_app').replaceAll(r'${appname}', distributor);
  }
}
