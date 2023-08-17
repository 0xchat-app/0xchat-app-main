
import 'package:flutter/cupertino.dart';

/// iOS Router Style
class SlideLeftToRightRoute<T> extends PageRoute<T> with CupertinoRouteTransitionMixin {
  final Widget Function(BuildContext? context) builder;
  final bool fullscreenDialog;
  final RouteSettings settings;

  SlideLeftToRightRoute({
    required this.builder,
    required this.settings,
    required this.fullscreenDialog
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  String? get title => '';

  @override
  bool get maintainState => true;
}