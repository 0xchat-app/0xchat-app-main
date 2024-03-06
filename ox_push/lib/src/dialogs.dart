import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_push/src/unifiedpush.dart';
import 'package:ox_push/src/constants.dart';

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

pickDistributorDialog(distributors) {
  return (BuildContext context) {
    return SimpleDialog(
        title: const Text('Select push distributor'),
        backgroundColor: ThemeColor.color180,
        children: distributors
            .map<Widget>(
              (d) => SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, d);
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 48.px,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(getShowTitle(d), style: TextStyle(color: ThemeColor.color0, fontSize: 16.px)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(getShowContent(d), style: TextStyle(color: ThemeColor.color10, fontSize: 12.px)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.5.px,
                      alignment: Alignment.bottomCenter,
                      color: ThemeColor.color140,
                    ),
                  ],
                ),
              ),
            )
            .toList());
  };
}

String getShowTitle(String distributor){
  if (distributor == ppnOxchat){
    return 'ntfy';
  } else if (distributor == ppnNextPush){
    return 'NextPush';
  } else if (distributor == ppnOxchat){
    return '0xchat';
  } else {
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
