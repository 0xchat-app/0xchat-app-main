import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

enum EDialogTime { oneHour, twelveHours, twentyFourHours, seventyTwoHours }

extension ESafeChatTimeToSecond on EDialogTime {
  int hour() {
    switch (this) {
      case EDialogTime.oneHour:
        return 1;
      case EDialogTime.twelveHours:
        return 12;
      case EDialogTime.twentyFourHours:
        return 24;
      case EDialogTime.seventyTwoHours:
        return 72;
    }
  }

  String toText() {
    switch (this) {
      case EDialogTime.oneHour:
        return '1' + Localized.text('ox_chat.hour');
      case EDialogTime.twelveHours:
        return '12' + Localized.text('ox_chat.hour');
      case EDialogTime.twentyFourHours:
        return '24' + Localized.text('ox_chat.hour');
      case EDialogTime.seventyTwoHours:
        return '72' + Localized.text('ox_chat.hour');
    }
  }
}


class CommonTimeDialog extends StatefulWidget {
  final void Function(int timestamp)? callback;
  int? expiration;
  CommonTimeDialog({this.callback,this.expiration});

  @override
  _CommonTimeDialogState createState() => new _CommonTimeDialogState();
}

class _CommonTimeDialogState extends State<CommonTimeDialog> {

  EDialogTime? get _getExpiration {
    int? expiration = widget.expiration;
    if(expiration == null || expiration == 0) return null;
    var getExpirationInHour = expiration / 3600;
    switch(getExpirationInHour){
      case 1:
        return EDialogTime.oneHour;
      case 12:
        return EDialogTime.twelveHours;
      case 24:
        return EDialogTime.twentyFourHours;
      case 72:
        return EDialogTime.seventyTwoHours;
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: 1,
        child: Container(
          alignment: Alignment.bottomCenter,
          height: Adapt.px(346),
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      EDialogTime time = EDialogTime.values[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          widget.callback?.call(time.hour() * 3600);
                        },
                        child: Column(
                          children: [
                            Container(
                              height: Adapt.px(56),
                              alignment: Alignment.center,
                              child: Text(
                                time.toText(),
                                style: TextStyle(
                                    fontSize: Adapt.px(16),
                                    color: ThemeColor.color0,
                                    fontWeight: _getExpiration == time ? FontWeight.w600 : FontWeight.w400
                                ),
                              ),
                            ),
                            _dividerWidget(index)
                          ],
                        ),
                      );
                    },
                    itemCount: EDialogTime.values.length,
                    shrinkWrap: true,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.callback?.call(0);
                  },
                  child: Container(
                    height: Adapt.px(56),
                    alignment: Alignment.center,
                    child: Text(
                      'Disable Auto-Delete',
                      style: TextStyle(fontSize: Adapt.px(16), color: ThemeColor.color0),
                    ),
                  ),
                ),
                Container(
                  height: Adapt.px(8),
                  color: ThemeColor.color190,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    OXNavigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: Adapt.px(56),
                    color: ThemeColor.color180,
                    child: Center(
                      child: Text(
                        Localized.text('ox_common.cancel'),
                        style: TextStyle(
                            fontSize: 16, color: ThemeColor.color0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dividerWidget(int index) {
    return Divider(
      height: Adapt.px(0.5),
      color: ThemeColor.color160,
    );
  }
}
