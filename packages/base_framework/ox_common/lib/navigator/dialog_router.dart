
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color kYLDialogBackgroundColor = Colors.black.withOpacity(0.5);

/// A route used for Dialog navigation, implementation can be referred to from _DialogRoute
class OXDialogRoute<T extends Object?> extends PopupRoute<T> {

  OXDialogRoute({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    Color? barrierColor = const Color(0x80000000),
    String? barrierLabel,
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    RouteSettings? settings,
    Function(T result)? reverseAnimateFinish
  }) : _pageBuilder = pageBuilder,
       _barrierDismissible = barrierDismissible,
       _barrierLabel = barrierLabel,
       _barrierColor = barrierColor,
       _transitionDuration = transitionDuration,
       _transitionBuilder = transitionBuilder,
       _reverseAnimateFinish = reverseAnimateFinish,
       super(settings: settings);

  final RoutePageBuilder _pageBuilder;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String? get barrierLabel => _barrierLabel;
  final String? _barrierLabel;

  @override
  Color? get barrierColor => _barrierColor;
  final Color? _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  final RouteTransitionsBuilder? _transitionBuilder;

  final Function(T result)? _reverseAnimateFinish;

  /// Callback value from page pop
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
    if (_transitionBuilder == null) {
      return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linearToEaseOut,
            reverseCurve: Curves.linearToEaseOut.flipped,
          ),
          child: child);
    } // Some default transition
    return _transitionBuilder!(context, animation, secondaryAnimation, child);
  }

  @override
  bool didPop(T? result) {
    this.result = result;
    return super.didPop(result);
  }
}

class OXMaterialPageRoute<T> extends PageRoute<T> {

  OXMaterialPageRoute({
    required this.builder,
    RouteSettings? settings,
    this.maintainState = true,
    this.opaque = true,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is MaterialPageRoute || previousRoute is CupertinoPageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return (nextRoute is MaterialPageRoute && !nextRoute.fullscreenDialog)
        || (nextRoute is CupertinoPageRoute && !nextRoute.fullscreenDialog);
  }

  @override
  final bool opaque;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget result = builder(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
          'The builder for route "${settings.name}" returned null.\n'
          'Route builders must never return null.'
        );
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions<T>(this, context, animation, secondaryAnimation, child);
  }
}

/// Show dialog, with the callback triggered at the moment of pop
Future<T?> showYLEDialog<T extends Object?>({
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
      OXDialogRoute<T>(
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
        barrierLabel: barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: barrierColor ?? kYLDialogBackgroundColor,
        transitionDuration: transitionDuration ?? Duration(milliseconds: 200),
        transitionBuilder: transitionBuilder,
        reverseAnimateFinish: reverseAnimateFinish,
      )
  );
}

/// Show dialog, with the callback triggered when the pop animation is complete
Future<T?> showYLEDialogUntilAnimateFinish<T extends Object?>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool? barrierDismissible,
  String? barrierLabel,
  Color? barrierColor,
  Duration? transitionDuration,
  RouteTransitionsBuilder? transitionBuilder,
}) {
  Completer<T?>? completer = Completer<T?>();
  showYLEDialog<T?>(
    context: context,
    builder: builder,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    transitionBuilder: transitionBuilder,
    reverseAnimateFinish: (result) {
      completer?.complete(result);
      completer = null;
    }
  );
  return completer?.future ?? Future.value(null);
}

/// Show bottom sheet-style list dialog, with the callback triggered when the pop animation is complete
Future<T?> showYLEActionDialogUntilAnimateFinish<T extends Object?>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool? barrierDismissible,
  String? barrierLabel,
  Color? barrierColor,
  Duration? transitionDuration,
  RouteTransitionsBuilder? transitionBuilder,
}) {
  return showYLEDialogUntilAnimateFinish<T?>(
    context: context,
    builder: builder,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: Duration(milliseconds: 335), // The official time of Flutter is _kModalPopupTransitionDuration = Duration(milliseconds: 335)
    transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      var _animation = CurvedAnimation(
        parent: animation,
        curve: Curves.linearToEaseOut,
        reverseCurve: Curves.linearToEaseOut.flipped,
      );
      var _offsetTween = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: const Offset(0.0, 0.0),
      );
      return Align(
        alignment: Alignment.bottomCenter,
        child: FractionalTranslation(
          translation: _offsetTween.evaluate(_animation),
          child: child,
        ),
      );
    },
  );
}

/// Show a bottom sheet-style list dialog, with the callback triggered at the moment of pop.
Future<T?> showYLEActionDialog<T extends Object?>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool? barrierDismissible,
  String? barrierLabel,
  Color? barrierColor,
  Duration? transitionDuration,
  RouteTransitionsBuilder? transitionBuilder,
}) {
  return showYLEDialog<T?>(
    context: context,
    builder: builder,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration ?? Duration(milliseconds: 335),
    transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      var _animation = CurvedAnimation(
        parent: animation,
        curve: Curves.linearToEaseOut,
        reverseCurve: Curves.linearToEaseOut.flipped,
      );
      var _offsetTween = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: const Offset(0.0, 0.0),
      );
      return Align(
        alignment: Alignment.bottomCenter,
        child: FractionalTranslation(
          translation: _offsetTween.evaluate(_animation),
          child: child,
        ),
      );
    },
  );
}
