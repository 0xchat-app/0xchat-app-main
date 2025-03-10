
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';

class OXWindowManager with WindowListener {

  Map<String, String> windowInfo = {};

  Future initWindow() async {
    if (!PlatformUtils.isDesktop) return;

    await windowManager.ensureInitialized();

    await loadWindowInfo();

    await windowManager.waitUntilReadyToShow(WindowOptions(
      title: '0xchat',
      size: Size(windowWidth, windowHeight),
      minimumSize: WindowInfoEx.minWindowSize,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      windowButtonVisibility: true,
    ));

    if (windowPositionX == null && windowPositionY == null) {
      await windowManager.center();
    } else {
      await windowManager.setPosition(Offset(windowPositionX ?? 0.0, windowPositionY ?? 0.0));
    }
    await windowManager.setPreventClose(true);

    await windowManager.show();

    addWindowObserver();
  }

  void addWindowObserver() {
    windowManager.addListener(this);
  }

  void onWindowResized() async {
    final size = await windowManager.getSize();
    windowWidth = size.width;
    windowHeight = size.height;
    saveWindowInfo();
  }

  void onWindowMoved() async {
    final position = await windowManager.getPosition();
    windowPositionX = position.dx;
    windowPositionY = position.dy;
    saveWindowInfo();
  }

  /// Emitted when the window is going to be closed.
  void onWindowClose() {
    windowManager.hide();
  }

  /// Emitted when the window gains focus.
  void onWindowFocus() {
    windowManager.show();
  }
}

extension WindowInfoEx on OXWindowManager {
  get windowInfoStoreKey => 'WindowInfoStoreKey';
  get windowInfoSizeWidthKey => 'WindowInfoSizeWidth';
  get windowInfoSizeHeightKey => 'WindowInfoSizeHeight';
  get windowInfoPositionXKey => 'WindowInfoPositionX';
  get windowInfoPositionYKey => 'WindowInfoPositionY';

  static Size get minWindowSize => Size(430, 600);

  static Size get defaultWindowSize => Size(850, 850);

  Future saveWindowInfo() async {
    OXCacheManager.defaultOXCacheManager.saveForeverData(windowInfoStoreKey, windowInfo);
  }

  Future loadWindowInfo() async {
    final value = await OXCacheManager.defaultOXCacheManager.getForeverData(windowInfoStoreKey);
    if (value is Map) {
      try {
        windowInfo = value.cast<String, String>();
      } catch (e) {
        LogUtil.e('[OXWindowManager - loadWindowInfo] $e');
      }
    }
  }

  double get windowWidth {
    final value = windowInfo[windowInfoSizeWidthKey];
    if (value == null || value.isEmpty) return defaultWindowSize.width;

    return double.tryParse(value) ?? defaultWindowSize.width;
  }

  set windowWidth(double value) {
    windowInfo[windowInfoSizeWidthKey] = value.toStringAsFixed(2);
  }

  double get windowHeight {
    final value = windowInfo[windowInfoSizeHeightKey];
    if (value == null || value.isEmpty) return defaultWindowSize.height;

    return double.tryParse(value) ?? defaultWindowSize.height;
  }

  set windowHeight(double value) {
    windowInfo[windowInfoSizeHeightKey] = value.toStringAsFixed(2);
  }

  double? get windowPositionX {
    final value = windowInfo[windowInfoPositionXKey];
    if (value == null || value.isEmpty) return null;

    return double.tryParse(value);
  }

  set windowPositionX(double? value) {
    windowInfo[windowInfoPositionXKey] = value?.toStringAsFixed(2) ?? '';
  }

  double? get windowPositionY {
    final value = windowInfo[windowInfoPositionYKey];
    if (value == null || value.isEmpty) return null;

    return double.tryParse(value);
  }

  set windowPositionY(double? value) {
    windowInfo[windowInfoPositionYKey] = value?.toStringAsFixed(2) ?? '';
  }
}

