import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ox_common/dialog/image_picker_handler.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ImagePicker extends StatelessWidget {
  late ImagePickerHandler _listener;
  late AnimationController _controller;
  late BuildContext context;

  ImagePicker(this._listener, this._controller);

  late Animation<double> _drawerContentsOpacity;
  late Animation<Offset> _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      //Add animation
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    _listener.pickerShowing = true;
    if (_controller == null || _drawerDetailsPosition == null || _drawerContentsOpacity == null) {
      return;
    }
    _controller.forward();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => this,
    );
  }

  void dispose() {
    _controller.dispose();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    _controller.reverse();
    startTime();
    _listener.pickerShowing = false;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new GestureDetector(
      onTap: () => dismissDialog(), //Off-screen disappearance
      child: new Material(
          type: MaterialType.transparency,
          child: new Opacity(
            opacity: 1,
            child: new GestureDetector(
              onTap: () => dismissDialog(),
              child: new Container(
                decoration: BoxDecoration(
                  color: ThemeColor.dark04,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Adapt.px(4)),
                    topRight: Radius.circular(Adapt.px(4)),
                    bottomLeft: Radius.circular(Adapt.px(4)),
                    bottomRight: Radius.circular(Adapt.px(4)),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new GestureDetector(
                      onTap: () => _listener.openCamera(),
                      child: roundedTopButton(
                        Localized.text('ox_common.camera'),
                        EdgeInsets.all(0),
                        Colors.transparent,
                        ThemeColor.gray02,
                      ),
                    ),
                    new Container(
                      height: Adapt.px(2),
                      color: ThemeColor.dark02,
                    ),
                    new GestureDetector(
                      onTap: () => _listener.openGallery(),
                      child: roundedNoRadiusButton(
                        Localized.text('ox_common.choose_from_album'),
                        EdgeInsets.all(0),
                        Colors.transparent,
                        ThemeColor.gray02,
                      ),
                    ),
                    new Container(
                      height: Adapt.px(2),
                      color: ThemeColor.dark02,
                    ),
                    new GestureDetector(
                      onTap: () => dismissDialog(),
                      child: new Padding(
                        padding: EdgeInsets.all(0),
                        child: roundedBottomButton(
                          Localized.text('ox_common.dialog_cancel'),
                          EdgeInsets.all(0),
                          Colors.transparent,
                          ThemeColor.gray02,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget roundedTopButton(String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(10.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0)),
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(color: textColor, fontSize: 20.0, fontWeight: FontWeight.normal),
      ),
    );
    return loginBtn;
  }

  Widget roundedBottomButton(String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(10.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.only(bottomLeft: const Radius.circular(10.0), bottomRight: const Radius.circular(10.0)),
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(color: textColor, fontSize: 20.0, fontWeight: FontWeight.normal),
      ),
    );
    return loginBtn;
  }

  Widget roundedNoRadiusButton(String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(10.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(0.0)),
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(color: textColor, fontSize: 20.0, fontWeight: FontWeight.normal),
      ),
    );
    return loginBtn;
  }
}
