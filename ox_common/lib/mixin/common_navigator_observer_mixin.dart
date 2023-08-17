
import 'package:flutter/cupertino.dart';
import 'package:ox_common/navigator/navigator.dart';

/// Provides monitoring of page stack related changes
/// Life cycle sequence：
/// A push B
/// didPush -> B.initState;
/// B pop to A
/// didPop -> B.dispose
mixin NavigatorObserverMixin<T extends StatefulWidget> on State<T> implements NavigatorObserver {

  NavigatorState? get navigator => Navigator.of(context);

  @override
  void initState() {
    super.initState();
    OXNavigator.observer.add(this);
  }

  @override
  void dispose() {
    removeObserver();
    super.dispose();
  }

  void removeObserver() {
    OXNavigator.observer.remove(this);
  }

  @protected
  @mustCallSuper
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // push the next page to remove this page listening
    removeObserver();
  }

  @protected
  @mustCallSuper
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) { }

  @protected
  @mustCallSuper
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) { }

  @protected
  @mustCallSuper
  void didReplace({ Route<dynamic>? newRoute, Route<dynamic>? oldRoute }) { }

  @protected
  @mustCallSuper
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) { }

  @protected
  @mustCallSuper
  void didStopUserGesture() { }
}