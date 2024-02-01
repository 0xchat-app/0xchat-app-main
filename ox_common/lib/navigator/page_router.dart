
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

class TransparentPageRoute<T> extends PageRouteBuilder<T> {
  final RouteSettings settings;

  TransparentPageRoute({
    required WidgetBuilder builder,
    required this.settings,
  }) : super(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: child,
      );
    },
  );
}

class NoAnimationPageRoute<T> extends PageRouteBuilder<T> {
  final RouteSettings settings;

  NoAnimationPageRoute({
    required WidgetBuilder builder,
    required this.settings,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}