
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

export 'package:visibility_detector/visibility_detector.dart';

/// A UI refresh optimization plug-in, to avoid page setState in the push process caused by animation stall
/// To use this mixin, do not override the build method and put the UI presentation in the buildBody
mixin OXUIRefreshMixin<T extends StatefulWidget> on State<T> {

  Completer allowSetStateCompleter = Completer();

  @protected
  String get stateKey => this.runtimeType.toString();

  @override
  Widget build(BuildContext ctx) {
    return VisibilityDetector(
      key: Key(stateKey),
      child: buildBody(ctx),
      onVisibilityChanged: onVisibilityChanged,
    );
  }

  @protected
  Widget buildBody(BuildContext context);

  @mustCallSuper
  void onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      if (!allowSetStateCompleter.isCompleted) {
        allowSetStateCompleter.complete(true);
      }
    }
  }

  @override
  void setState(fn) async {
    await allowSetStateCompleter.future;
    super.setState(fn);
  }
}


mixin YLUIRefreshKeepAliveMixin<T extends StatefulWidget> on AutomaticKeepAliveClientMixin<T> {

  Completer allowSetStateCompleter = Completer();

  @protected
  String get stateKey => this.runtimeType.toString();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: Key(stateKey),
      child: buildBody(context),
      onVisibilityChanged: onVisibilityChanged,
    );
  }

  @protected
  Widget buildBody(BuildContext context);

  @mustCallSuper
  void onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      if (!allowSetStateCompleter.isCompleted) {
        allowSetStateCompleter.complete(true);
      }
    }
  }

  @override
  void setState(fn) async {
    await allowSetStateCompleter.future;
    super.setState(fn);
  }
}