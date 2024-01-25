import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/data_picker/date_model.dart';
import 'package:ox_localizable/ox_localizable.dart';

typedef DateChangedCallback(DateTime time);
typedef DateCancelledCallback();
typedef String? StringAtIndexCallBack(int index);

class DatePicker {
  ///
  /// Display date picker bottom sheet.
  ///
  static Future<DateTime?> showDatePicker(
      BuildContext context, {
        bool showTitleActions = true,
        String? title,
        DateTime? minTime,
        DateTime? maxTime,
        DateChangedCallback? onChanged,
        DateChangedCallback? onConfirm,
        DateCancelledCallback? onCancel,
        DateTime? currentTime,
      }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        title:title,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: DatePickerModel(
          currentTime: currentTime,
          maxTime: maxTime,
          minTime: minTime,
        ),
      ),
    );
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    this.barrierLabel,
    this.title,
    RouteSettings? settings,
    BasePickerModel? pickerModel,
  })  : this.pickerModel = pickerModel ?? DatePickerModel(),

        super(settings: settings);
  final String? title;
  final bool? showTitleActions;
  final DateChangedCallback? onChanged;
  final DateChangedCallback? onConfirm;
  final DateCancelledCallback? onCancel;
  final BasePickerModel pickerModel;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(
        onChanged: onChanged,
        route: this,
        title:title,
        pickerModel: pickerModel,
      ),
    );
    return InheritedTheme.captureAll(context, bottomSheet);
  }
}

class _DatePickerComponent extends StatefulWidget {
  _DatePickerComponent({
    Key? key,
    required this.route,
    required this.pickerModel,
    this.title,
    this.onChanged,
  }) : super(key: key);

  final DateChangedCallback? onChanged;

  final _DatePickerRoute route;

  final String? title;

  final BasePickerModel pickerModel;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<_DatePickerComponent> {
  late FixedExtentScrollController leftScrollCtrl,
      middleScrollCtrl,
      rightScrollCtrl;

  @override
  void initState() {
    super.initState();
    refreshScrollOffset();
  }

  void refreshScrollOffset() {
    leftScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentLeftIndex());
    middleScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentMiddleIndex());
    rightScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentRightIndex());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation!,
        builder: (BuildContext context, Widget? child) {
          final double bottomPadding = MediaQuery.of(context).padding.bottom;
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(
                widget.route.animation!.value,
                showTitleActions: widget.route.showTitleActions!,
                bottomPadding: bottomPadding,
              ),
              child: GestureDetector(
                child: Material(
                  color:  ThemeColor.dark02,
                  child: _renderPickerView(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.pickerModel.finalTime()!);
    }
  }

  Widget _renderPickerView() {
    Widget itemView = _renderItemView();
    if (widget.route.showTitleActions == true) {
      return  Column(
        children: <Widget>[
          _renderTitleActionsView(),
          itemView,
        ],
      );
    }
    return itemView;
  }

  Widget _renderColumnView(
      ValueKey key,
      StringAtIndexCallBack stringAtIndexCB,
      ScrollController scrollController,
      int layoutProportion,
      ValueChanged<int> selectedChangedWhenScrolling,
      ValueChanged<int> selectedChangedWhenScrollEnd,
      {int paddingLeft = 0,
      int paddingRight = 0,
      double offAxisFraction = 0}) {
    return Container(
      height: Adapt.px(230),
      child: NotificationListener(
        onNotification: (ScrollNotification notification) {
          if (notification.depth == 0 &&
              notification is ScrollEndNotification &&
              notification.metrics is FixedExtentMetrics) {
            final FixedExtentMetrics metrics =
            notification.metrics as FixedExtentMetrics;
            final int currentItemIndex = metrics.itemIndex;
            selectedChangedWhenScrollEnd(currentItemIndex);
          }
          return false;
        },
        child: CupertinoPicker.builder(
          key: key,
          offAxisFraction: offAxisFraction,
          backgroundColor: ThemeColor.dark02,
          scrollController: scrollController as FixedExtentScrollController,
          itemExtent:40.0,
          onSelectedItemChanged: (int index) {
            selectedChangedWhenScrolling(index);
          },
          useMagnifier: true,
          selectionOverlay: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: ThemeColor.dark04,
                ),
                bottom: BorderSide(
                  width: 1,
                  color: ThemeColor.dark04,
                ),
              ),
            ),
          ),
          itemBuilder: (BuildContext context, int index) {
            final content = stringAtIndexCB(index);
            if (content == null) {
              return null;
            }
            return Container(

              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: Adapt.px(paddingLeft),
                  right:Adapt.px(paddingRight)
              ),
              child: Text(
                content,
                style: TextStyle(color: ThemeColor.white01, fontSize: Adapt.px(18)),
                textAlign: TextAlign.start,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _renderItemView() {
    return Container(
      color: ThemeColor.dark02,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: widget.pickerModel.layoutProportions()[0] > 0
                ? Expanded(child: _renderColumnView(
                ValueKey(widget.pickerModel.currentLeftIndex()),
                widget.pickerModel.leftStringAtIndex,
                leftScrollCtrl,
                widget.pickerModel.layoutProportions()[0], (index) {
              widget.pickerModel.setLeftIndex(index);
            }, (index) {
              setState(() {
                refreshScrollOffset();
                _notifyDateChanged();
              });
            },paddingLeft: 70,offAxisFraction : -0.5))
                : null,
          ),
          Container(
            child: widget.pickerModel.layoutProportions()[1] > 0
                ? Container(
              width: Adapt.px(40),
              child: _renderColumnView(
                  ValueKey(widget.pickerModel.currentLeftIndex()),
                  widget.pickerModel.middleStringAtIndex,
                  middleScrollCtrl,
                  widget.pickerModel.layoutProportions()[1], (index) {
                widget.pickerModel.setMiddleIndex(index);
              }, (index) {
                setState(() {
                  refreshScrollOffset();
                  _notifyDateChanged();
                });
              }),
            )
                : null,
          ),
         Expanded(child:  Container(
           child: widget.pickerModel.layoutProportions()[2] > 0
               ?  _renderColumnView(
               ValueKey(widget.pickerModel.currentMiddleIndex() * 100 +
                   widget.pickerModel.currentLeftIndex()),
               widget.pickerModel.rightStringAtIndex,
               rightScrollCtrl,
               widget.pickerModel.layoutProportions()[2], (index) {
             widget.pickerModel.setRightIndex(index);
           }, (index) {
             setState(() {
               refreshScrollOffset();
               _notifyDateChanged();
             });
           },paddingRight: 60,offAxisFraction: 0.3)
               : null,
         ),)
        ],
      ),
    );
  }

  // Title View
  Widget _renderTitleActionsView() {
    final done = _localeDone();
    final cancel = _localeCancel();

    return Container(
      // height: theme.titleHeight,
      color: ThemeColor.dark02,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height:44,
                child: CupertinoButton(
                  pressedOpacity: 0.3,
                  padding: EdgeInsets.only(left: 16, top: 0),
                  child: Text(
                    '$cancel',
                    style: TextStyle(
                        color: ThemeColor.gray02,
                        fontSize: Adapt.px(14)
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (widget.route.onCancel != null) {
                      widget.route.onCancel!();
                    }
                  },
                ),
              ),
              Container(
                child: Text(
                  widget.title ?? 'time',
                  style: TextStyle(
                      color: ThemeColor.white01,
                      fontSize: Adapt.px(17)
                  ),
                ),
              ),
              Container(
                height: Adapt.px(60),
                child: CupertinoButton(
                  pressedOpacity: 0.3,
                  padding: EdgeInsets.only(right: 16, top: 0),
                  child: Text(
                    '$done',
                    style: TextStyle(
                        color: ThemeColor.main,
                        fontSize: Adapt.px(14)
                    ),
                  ),
                  onPressed: () {
                    DateTime finalTime = widget.pickerModel.finalTime()!;
                    OXNavigator.pop(context, finalTime);
                    if (widget.route.onConfirm != null) {
                      widget.route.onConfirm!(widget.pickerModel.finalTime()!);
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              left: Adapt.px(15)
            ),
            child:Row(
              children: [
                CommonImage(
                  iconName: "icon_info_solid.png",
                  width: Adapt.px(15),
                  height: Adapt.px(15),
                  useTheme: false,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: Adapt.px(10)
                  ),
                  child: Text(
                    Localized.text('ox_common.search_date_scope'),
                    style: TextStyle(
                      color: ThemeColor.gray02,
                      fontSize: Adapt.px(12)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _localeDone() {
    return Localized.text('ox_common.confirm');
  }

  String _localeCancel() {
    return Localized.text('ox_common.cancel');
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(
      this.progress,
       {
        this.showTitleActions,
        this.bottomPadding = 0,
      });

  final double progress;
  final int? itemCount;
  final bool? showTitleActions;
  final double bottomPadding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = Adapt.px(230);
    if (showTitleActions == true) {
      maxHeight += Adapt.px(50);
    }

    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight + bottomPadding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
