import 'package:flutter/material.dart';
import 'package:ox_network/src/utils/network_adapt.dart';

/// Title: CommonToast
/// Copyright: Copyright (c) 2018
/// CreateTime: 2021/4/6 4:21 PM
///
/// @author john
/// @CheckItem Fill in by oneself
class CommonToast {
  static CommonToast get instance => _getInstance();
  static CommonToast? _instance;

  static CommonToast _getInstance() {
    if (_instance == null) {
      _instance = new CommonToast._internal();
    }
    return _instance!;
  }

  CommonToast._internal();
  static OverlayEntry? _entry;

  /// Show Toast Message
  ///
  /// message: message
  /// duration: milliseconds
   void show(BuildContext context, String message, {int duration = 2000}) {
    if (_entry != null) return;
    _entry = OverlayEntry(builder: (context) {
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: NetAdapt.px(36),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: NetAdapt.px(22),
            vertical: NetAdapt.px(12),
          ),
          decoration: BoxDecoration(
            color: Color(0xcc000000),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Material(
            color: Colors.transparent,
            child: Text(
              message,
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    });
    Overlay.of(context).insert(_entry!);
    Future.delayed(Duration(milliseconds: duration)).then((value) {
      // You can remove layers by calling OverlayEntry's remove method.
      _entry?.remove();
      _entry = null;
    });
  }
}
