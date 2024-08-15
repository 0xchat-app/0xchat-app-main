
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io' show Platform;

import 'package:ox_common/navigator/navigator.dart';

class Adapt {
  static MediaQueryData? mediaQuery;
  static double? _width;
  static double? _height;
  static double? _topbarH;
  static double? _botbarH;
  static double? _pixelRatio;
  static double get devicePixelRatio => _pixelRatio ?? 1;
  static num statusBarHeight = 0.0;
  static double? _ratioW;
  static var _ratioH;
  static double _textScaleFactor = 1.0;

  static get isInitialized => _ratioW != null;

  static init({int standardW = 0, int standardH = 0}) {
    final context = OXNavigator.navigatorKey.currentContext;
    final view = context != null ? View.of(context) : window;

    mediaQuery = MediaQueryData.fromView(view);
    _width = mediaQuery?.size.width;
    _height = mediaQuery?.size.height;
    _topbarH = mediaQuery?.padding.top;
    _botbarH = mediaQuery?.padding.bottom;
    _pixelRatio = mediaQuery?.devicePixelRatio;
    _textScaleFactor = mediaQuery?.textScaleFactor ?? _textScaleFactor;

    if (_width != null) {
      if (Platform.isIOS && _width! > 375.0)
        _ratioW = 1;
      else
        _ratioW = _width! / standardW;
    }

    if (_height != null) {
      _ratioH = _height! / standardH;
    }
  }

  static double px(number) {
    if (!(_ratioW is double || _ratioW is int)) {
      Adapt.init(standardW: 375, standardH: 812);
    }
    return number * _ratioW;
  }

  static double sp(number, {bool allowFontScaling = false}) {
    final fontSize = allowFontScaling ? px(number) * _textScaleFactor : px(number);
    return fontSize.floorToDouble();
  }

  static py(number) {
    if (!(_ratioH is double || _ratioH is int)) {
      Adapt.init(standardW: 375, standardH: 812);
    }
    return number * _ratioH;
  }

  static onepx() {
    if (_pixelRatio == null) {
      return 0;
    }
    return 1 / _pixelRatio!;
  }

  static screenW() {
    return _width;
  }

  static screenH() {
    return _height;
  }

  static padTopH() {
    return Platform.isAndroid ? statusBarHeight + 0.0 : _topbarH;
  }

  static padBotH() {
    return _botbarH;
  }
}

extension AdaptEx on num {
  double get px => Adapt.px(this);
  double get py => Adapt.py(this);
  double get sp => Adapt.sp(this);
}