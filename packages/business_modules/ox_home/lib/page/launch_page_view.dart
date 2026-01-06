import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:rive/rive.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_home/page/home_tabbar.dart';

class LaunchPageView extends StatefulWidget {
  const LaunchPageView({super.key});

  @override
  State<StatefulWidget> createState() {
    return LaunchPageViewState();
  }
}

class LaunchPageViewState extends State<LaunchPageView> {
  final riveFileNames = 'Launcher';
  final stateMachineNames = 'Button';
  final riveInputs = 'Press';

  late StateMachineController? riveControllers;
  Artboard? riveArtboards;

  String _localPasscode = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _localPasscode = UserConfigTool.getSetting(StorageSettingKey.KEY_PASSCODE.name, defaultValue: '');
    _loadRiveFile();
    _onLoaded();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (riveArtboards != null && riveControllers != null) {
      return Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            width: Adapt.px(360),
            height: Adapt.px(360),
            margin: EdgeInsets.only(
              bottom: Adapt.px(100),
            ),
            child: Rive(artboard: riveArtboards!),
          ),
        ),
      );
    }
    return Container();
  }

  Future<void> _loadRiveFile() async {
    await RiveFile.initialize();

    String animPath =
        "packages/ox_home/assets/${ThemeManager.images(riveFileNames)}.riv";

    final data = await rootBundle.load(animPath);
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineNames);
    //
    if (controller != null) {
      artboard.addController(controller);
      riveControllers = controller;
      riveArtboards = artboard;
      setState(() {});
    }

    StateMachineController? animController = riveControllers;

    final input = animController?.findInput<bool>(riveInputs);
    if (input != null) {
      input.value = true;
    }
  }

  void _onLoaded() {
    Future.delayed(const Duration(milliseconds: 2500), () async {
      if (_localPasscode.isNotEmpty) {
        OXModuleService.pushPage(context, 'ox_usercenter', 'VerifyPasscodePage', {});
      } else {
        Navigator.of(context).pushReplacement(CustomRouteFadeIn(const HomeTabBarPage()));
      }
    });
  }
}

class CustomRouteFadeIn<T> extends PageRouteBuilder<T> {
  final Widget widget;
  CustomRouteFadeIn(this.widget)
      : super(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation1,
            Animation<double> animation2,
          ) =>
              widget,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation1,
            Animation<double> animation2,
            Widget child,
          ) {
            return FadeTransition(
              opacity: Tween(begin: 0.0, end: 2.0).animate(
                CurvedAnimation(
                  parent: animation1,
                  curve: Curves.fastOutSlowIn,
                ),
              ),
              child: child,
            );
          },
        );
}
