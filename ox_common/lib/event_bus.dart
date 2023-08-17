import 'dart:ui';

import 'package:event_bus/event_bus.dart';
import 'package:ox_common/widgets/physics/custom_scroll_physics.dart';

///When using an EventBus listener, note that StreamSubscription is used and cancel is called when the page is destroyed
final EventBus commonEventBus = EventBus();

///=>>>>>>>>>>>>>>>>>>>>>>ox_common

///WebSocket switch
class WSSwitchState {
  WSSwitchState();
}

///=>>>>>>>>>>>>>>>>>>>>>>ox_common

///=>>>>>>>>>>>>>>>>>>>>>>ox_home
class HomeRefreshCompleteEvent{
  HomeRefreshCompleteEvent();
}
///=>>>>>>>>>>>>>>>>>>>>>>ox_home

///Slide to border notification
class ScrollSlideMaxEvent {
  ScrollSlideType type;
  ScrollSlideMaxEvent(this.type);
}

///Notification rolling state
class ScrollStateEvent {
  bool state;
  ScrollStateEvent(this.state);
}

class OptionalEditSelectEvent {
  bool isSelect;
  OptionalEditSelectEvent(this.isSelect);
}

///Pinned
class OptionalEditTopEvent {
  int position;
  OptionalEditTopEvent(this.position);
}

///Delete Select and refresh
class OptionalEditDeleteRefreshEvent {
  OptionalEditDeleteRefreshEvent();
}

///Completion time transfer
class OptionalEditCompleteEvent {
  OptionalEditCompleteEvent();
}

///=>>>>>>>>>>>>>>>>>>>>>>AppLifecycleState

/// APP Status
class AppLifecycleStateEvent{
  AppLifecycleState state;
  AppLifecycleStateEvent(this.state);
}

///=>>>>>>>>>>>>>>>>>>>>>>AppLifecycleState


///*************CacheTime Refresh*****start*****
class CacheTimeEvent{
  CacheTimeEvent();
}
///*************CacheTime Refresh*****end*****