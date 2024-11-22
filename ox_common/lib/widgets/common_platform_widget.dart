import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';

class PlatformWidget extends StatelessWidget {
  final Widget? mobileBuilder;
  final Widget? desktopBuilder;
  final Widget? webBuilder;

  const PlatformWidget({
    Key? key,
    this.mobileBuilder,
    this.desktopBuilder,
    this.webBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget emptySizedBox = const SizedBox();
    if (PlatformUtils.isMobile) {
      return mobileBuilder ?? emptySizedBox;
    } else if (PlatformUtils.isDesktop) {
      return desktopBuilder ?? emptySizedBox;
    } else if (PlatformUtils.isWeb && webBuilder != null) {
      return webBuilder ?? emptySizedBox;
    }
    return emptySizedBox;
  }
}