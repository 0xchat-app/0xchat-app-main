
import 'dart:async';

import 'package:flutter/material.dart';

Color kYLDialogBackgroundColor = Colors.black.withOpacity(0.5);

/// Route for sidebar jumps
class OXSideBarRoute<T extends Object?> extends PopupRoute<T> {

  OXSideBarRoute({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    Color? barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteSettings? settings,
    Function(T result)? reverseAnimateFinish
  }) : _pageBuilder = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _reverseAnimateFinish = reverseAnimateFinish,
        super(settings: settings);

  final RoutePageBuilder _pageBuilder;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String? get barrierLabel => null;

  @override
  Color? get barrierColor => _barrierColor;
  final Color? _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  final Function(T result)? _reverseAnimateFinish;

  /// The callback value of the page pop
  T? result;

  @override
  void install() {
    super.install();
  }

  @override
  void dispose() {
    Function.apply(_reverseAnimateFinish ?? (value){}, [this.result]);
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Semantics(
      child: _pageBuilder(context, animation, secondaryAnimation),
      scopesRoute: true,
      explicitChildNodes: true,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    var _animation = CurvedAnimation(
      parent: animation,
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.linearToEaseOut.flipped,
    );
    var _offsetTween = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    );
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionalTranslation(
        translation: _offsetTween.evaluate(_animation),
        child: child,
      ),
    );
  }

  @override
  bool didPop(T? result) {
    this.result = result;
    return super.didPop(result);
  }
}

/// Displays the sidebar. The callback time is the moment the pop is triggered
Future<T?> showSidebarPage<T extends Object?>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool? barrierDismissible,
  String? barrierLabel,
  Color? barrierColor,
  Duration? transitionDuration,
  RouteTransitionsBuilder? transitionBuilder,
  Function(T result)? reverseAnimateFinish,
}) {
  return Navigator.of(context, rootNavigator: true).push<T>(
    OXSideBarRoute<T>(
      settings: RouteSettings(
          name: builder(context).runtimeType.toString()
      ),
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        return Builder(
          builder: (BuildContext context) => pageChild,
        );
      },
      barrierDismissible: barrierDismissible ?? true,
      barrierColor: barrierColor ?? kYLDialogBackgroundColor,
      transitionDuration: transitionDuration ?? Duration(milliseconds: 200),
      reverseAnimateFinish: reverseAnimateFinish,
    ),
  );
}
