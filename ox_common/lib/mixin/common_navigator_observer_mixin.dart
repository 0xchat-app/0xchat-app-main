
import 'package:flutter/cupertino.dart';
import 'package:ox_common/navigator/navigator.dart';

/// Provides monitoring of page stack related changes
/// Life cycle sequence：
/// A push B
/// didPush -> B.initState;
/// B pop to A
/// didPop -> B.dispose
mixin NavigatorObserverMixin<T extends StatefulWidget> on State<T> implements RouteAware {

  NavigatorState? get navigator => Navigator.of(context);
  Route? get route => ModalRoute.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = this.route;
    if (route != null) {
      OXNavigator.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    if (mounted) {
      removeObserver();
    }
    super.dispose();
  }

  void removeObserver() {
    OXNavigator.routeObserver.unsubscribe(this);
  }

  @protected
  void didPopNext() { }

  @protected
  void didPush() { }

  @protected
  void didPop() { }

  @protected
  void didPushNext() { }
}