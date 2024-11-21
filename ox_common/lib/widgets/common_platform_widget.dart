import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';

class PlatformWidget extends StatelessWidget {
  final Widget Function(BuildContext context)? mobileBuilder;
  final Widget Function(BuildContext context)? desktopBuilder;
  final Widget Function(BuildContext context)? webBuilder;

  const PlatformWidget({
    Key? key,
    required this.mobileBuilder,
    required this.desktopBuilder,
    this.webBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isMobile(context)) {
      return mobileBuilder(context);
    } else if (PlatformUtils.isDesktop(context)) {
      return desktopBuilder(context);
    } else if (PlatformUtils.isWeb() && webBuilder != null) {
      return webBuilder(context);
    }
    return const SizedBox();
  }
}