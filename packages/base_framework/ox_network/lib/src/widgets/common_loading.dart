import 'package:flutter/material.dart';
import 'package:ox_network/src/utils/network_adapt.dart';

/// Title: loading
/// Copyright: Copyright (c) 2023
///
/// @author john
/// @CheckItem Fill in by oneself
class CommonLoading extends Dialog{
  final String message;
  ///Click on the background to see if you can exit
  final bool canceledOnTouchOutside;
  CommonLoading({this.canceledOnTouchOutside = false, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {

      return GestureDetector(
        onTap: (){
          _hideLoading(context);
        },
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: SizedBox(
              height: NetAdapt.px(90),
              width: NetAdapt.px(90),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.red,//TODO  Theme color configuration
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      NetAdapt.px(8),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: NetAdapt.px(35),
                      width: NetAdapt.px(35),
                      child: CircularProgressIndicator(
                        valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.white),//TODO  Theme color configuration
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: NetAdapt.px(12),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.tealAccent, //TODO  Theme color configuration
                          fontWeight: FontWeight.w400,
                          fontSize: NetAdapt.px(14.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  ///Hidden Loading
  void _hideLoading(BuildContext context) {
    Navigator.pop(context);
  }
}

class DialogRouter extends PageRouteBuilder{

  final Widget page;

  DialogRouter(this.page)
      : super(
    opaque: false,
    barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}