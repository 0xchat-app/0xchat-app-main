import 'dart:io';
import 'dart:math' as math;
import 'dart:math';
import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../utils/theme_color.dart';
import 'common_loading.dart';
import 'common_toast.dart';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

typedef DoubleClickAnimationListener = void Function();

class SmoothPageScrollPhysics extends ScrollPhysics {
  final double scrollSpeedMultiplier;

  const SmoothPageScrollPhysics({
    this.scrollSpeedMultiplier = 1.0,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  SmoothPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SmoothPageScrollPhysics(
      scrollSpeedMultiplier: scrollSpeedMultiplier,
      parent: buildParent(ancestor),
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return offset * scrollSpeedMultiplier;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.toleranceFor(position);
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity * scrollSpeedMultiplier,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  double frictionFactor(double overscrollFraction) {
    return 0.3 * math.pow(1 - overscrollFraction, 2);
  }

  @override
  SpringDescription get spring {
    return SpringDescription.withDampingRatio(
      mass: 0.5,
      stiffness: 100.0,
      ratio: 1.1,
    );
  }

  @override
  double get minFlingVelocity => kMinFlingVelocity * 0.5;

  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}

class CommonImageGallery extends StatefulWidget {
  final List<String> imageList;
  final String tag;
  final int initialPage;
  const CommonImageGallery(
      {required this.imageList, required this.tag, required this.initialPage});

  @override
  _CommonImageGalleryState createState() => _CommonImageGalleryState();
}

class _CommonImageGalleryState extends State<CommonImageGallery>
    with TickerProviderStateMixin {
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  late ExtendedPageController _pageController;
  Animation<double>? _doubleClickAnimation;
  late AnimationController _doubleClickAnimationController;
  late AnimationController _slideEndAnimationController;
  late Animation<double> _slideEndAnimation;
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  bool _isPopped = false;
  double _imageDetailY = 0;
  bool _showSwiper = true;
  List<double> doubleTapScales = <double>[1.0, 2.0];
  final StreamController<bool> rebuildSwiper =
      StreamController<bool>.broadcast();
  final StreamController<double> rebuildDetail =
      StreamController<double>.broadcast();

  bool isScrollComplete = true;

  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _pageController = ExtendedPageController(
      initialPage: widget.initialPage!,
      pageSpacing: 50,
      shouldIgnorePointerWhenScrolling: false,
    )..addListener(() {
        double? page = _pageController.page;
        if (page != null) {
          isScrollComplete = page % 1 == 0;
        }
      });
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);

    _slideEndAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _slideEndAnimationController.addListener(() {
      _imageDetailY = _slideEndAnimation.value;
      if (_imageDetailY == 0) {
        _showSwiper = true;
        rebuildSwiper.add(_showSwiper);
      }
      rebuildDetail.sink.add(_imageDetailY);
    });
  }

  void _handleSlideEnd(ExtendedImageSlidePageState state) {
    double angle = (math.atan2(state.offset.dy, state.offset.dx) * 180 / math.pi).abs();
    if (angle > 45 && angle < 135) {
      if (state.offset.dy > 100 && !_isPopped) {
        _isPopped = true;
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            // onPanUpdate: _handleDragUpdate,
            // onPanEnd: _handleDragEnd,
            onLongPress: _showBottomMenu,
            onTap: () {
              if (isScrollComplete) {
                OXNavigator.pop(context);
              }
            },
            child: ExtendedImageSlidePage(
              slidePageBackgroundHandler: (    Offset offset, Size pageSize){
                double opacity = 0.0;
                  opacity = offset.distance /
                      (Offset(pageSize.width, pageSize.height).distance / 2.0);
                return ThemeColor.color200.withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
              },
              key: slidePagekey,
              slideOffsetHandler: (
                Offset offset, {
                ExtendedImageSlidePageState? state,
              }) {
                if(_offset != Offset.zero){
                  _offset = offset;
                  return offset;
                }

                if (offset.dy < 0) {
                  _offset = Offset.zero;
                  return Offset(0, 0);
                }
                if(offset.dy > 1 && (-2 < offset.dx && offset.dx < 2)){
                  _offset = offset;
                  return offset;
                }
                _offset = Offset.zero;
                return Offset(0, 0);
              },
              slideScaleHandler: (
                Offset offset, {
                ExtendedImageSlidePageState? state,
              }) {
                return 1.0;
              },

              slideEndHandler: (
                Offset offset, {
                ExtendedImageSlidePageState? state,
                ScaleEndDetails? details,
              }) {
                _offset = Offset.zero;
                if (state == null || details == null) {
                  return false;
                }

                final double velocity = details.velocity.pixelsPerSecond.dy;

                const double positionThreshold = 200;
                const double velocityThreshold = 1000;

                if (offset.dy > 10 && velocity > 100 && isScrollComplete) {
                  return true;
                }

                if (offset.dy > positionThreshold && velocity > velocityThreshold && isScrollComplete) {
                  return true;
                }

                return false;
              },
              resetPageDuration: const Duration(milliseconds: 1),
              onSlidingPage: (ExtendedImageSlidePageState state) {
                // if (!state.isSliding) {
                // _handleSlideEnd(state);
                // }
              },
              child: ExtendedImageGesturePageView.builder(
                controller: _pageController,
                itemCount: widget.imageList.length,
                scrollDirection: Axis.horizontal,
                physics:  widget.imageList.length == 1 ? NeverScrollableScrollPhysics() : SmoothPageScrollPhysics(),
                canScrollPage: (GestureDetails? gestureDetails) {
                  return true;
                  // return _imageDetailY >= 0;
                  // return (gestureDetails?.totalScale ?? 1.0) <= 1.0;
                },
                itemBuilder: (BuildContext context, int index) {
                  return HeroWidget(
                    child: ExtendedImage.network(
                      widget.imageList[index],
                      loadStateChanged: (ExtendedImageState state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case LoadState.completed:
                            return null; // Use the completed image
                          case LoadState.failed:
                            return Center(
                              child: Text('Load failed'),
                            );
                        }
                        return null;
                      },
                      enableSlideOutPage: true,
                      onDoubleTap: (ExtendedImageGestureState state) {
                        ///you can use define pointerDownPosition as you can,
                        ///default value is double tap pointer down postion.
                        final Offset? pointerDownPosition =
                            state.pointerDownPosition;
                        final double? begin = state.gestureDetails!.totalScale;
                        double end;

                        //remove old
                        _doubleClickAnimation
                            ?.removeListener(_doubleClickAnimationListener);

                        //stop pre
                        _doubleClickAnimationController.stop();

                        //reset to use
                        _doubleClickAnimationController.reset();

                        if (begin == doubleTapScales[0]) {
                          end = doubleTapScales[1];
                        } else {
                          end = doubleTapScales[0];
                        }

                        _doubleClickAnimationListener = () {
                          //print(_animation.value);
                          state.handleDoubleTap(
                              scale: _doubleClickAnimation!.value,
                              doubleTapPosition: pointerDownPosition);
                        };
                        _doubleClickAnimation = _doubleClickAnimationController
                            .drive(Tween<double>(begin: begin, end: end));

                        _doubleClickAnimation!
                            .addListener(_doubleClickAnimationListener);

                        _doubleClickAnimationController.forward();
                      },
                      mode: ExtendedImageMode.gesture,
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          minScale: 0.9,
                          animationMinScale: 0.7,
                          maxScale: 3.0,
                          animationMaxScale: 3.5,
                          speed: 1.0,
                          inertialSpeed: 100.0,
                          initialScale: 1.0,
                          inPageView: false,
                          initialAlignment: InitialAlignment.center,
                        );
                      },
                    ),
                    tag: widget.imageList[index] + widget.tag,
                    slideType: SlideType.onlyImage,
                    slidePagekey: slidePagekey,
                  );
                  // );
                },
                onPageChanged: (int index) {
                  print('page changed to $index');
                },
              ),
              slideAxis: SlideAxis.both,
              slideType: SlideType.onlyImage,
              // onSlidingPage: (state) {
              //   print('Sliding state: ${state.toString()}');
              // },
            ),
          ),
          Positioned.directional(
            end: 16,
            textDirection: Directionality.of(context),
            bottom: 56,
            child: Container(
                width: 35.px,
                height: 35.px,
                decoration: BoxDecoration(
                    color: ThemeColor.color180,
                    borderRadius: BorderRadius.all(Radius.circular(35.px))),
                child: Center(
                  child: GestureDetector(
                    child: Icon(
                      Icons.save_alt,
                      color: Colors.white,
                      size: 24,
                    ),
                    onTap: _widgetShotAndSave,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _showBottomMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        padding: EdgeInsets.only(bottom: 30.px),
        color: ThemeColor.color180,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: new Material(
            type: MaterialType.transparency,
            child: new Opacity(
              opacity: 1, //Opacity containing a widget
              child: new GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: new Container(
                  decoration: BoxDecoration(
                    color: ThemeColor.color190,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () async {
                          await _widgetShotAndSave();
                          OXNavigator.pop(context);
                        },
                        child: Container(
                          height: 48.px,
                          padding: EdgeInsets.all(8.px),
                          alignment: FractionalOffset.center,
                          decoration: new BoxDecoration(
                            color: ThemeColor.color180,
                          ),
                          child: Text(
                            Localized.text('ox_chat.str_save_image'),
                            style: new TextStyle(
                                color: ThemeColor.gray02,
                                fontSize: 16.px,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      new Container(
                        height: 2.px,
                        color: ThemeColor.dark01,
                      ),
                      new GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 48.px,
                          padding: EdgeInsets.all(8.px),
                          alignment: FractionalOffset.center,
                          color: ThemeColor.color180,
                          child: Text(
                            'cancel'.commonLocalized(),
                            style: new TextStyle(
                              color: ThemeColor.gray02,
                              fontSize: 16.px,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _widgetShotAndSave() async {
    if (widget.imageList.isEmpty) return;
    OXLoading.show();
    final pageIndex = _pageController.page?.round() ?? 0;
    final imageUri = widget.imageList[pageIndex];

    final isNetworkImage = imageUri.startsWith('http');
    var result;
    if (isNetworkImage) {
      try {
        String fileName = imageUri.split('/').last.split('?').first;
        if (fileName.contains('.gif')) {
          final appDocDir = await getTemporaryDirectory();
          final savePath = appDocDir.path +
              "/image_${DateTime.now().millisecondsSinceEpoch}.gif";
          final response = await Dio().download(imageUri, savePath,
              options: Options(responseType: ResponseType.bytes));
          result = await ImageGallerySaver.saveFile(savePath);
        } else {
          var response = await Dio().get(imageUri,
              options: Options(responseType: ResponseType.bytes));
          result = await ImageGallerySaver.saveImage(
              Uint8List.fromList(response.data));
        }
      } catch (e) {
        unawaited(CommonToast.instance.show(context, e.toString()));
      }
    } else {
      final imageData = await File(imageUri).readAsBytes();

      result = await ImageGallerySaver.saveImage(Uint8List.fromList(imageData));
    }

    if (result != null) {
      unawaited(CommonToast.instance
          .show(context, Localized.text('ox_chat.str_saved_to_album')));
    } else {
      unawaited(CommonToast.instance
          .show(context, Localized.text('ox_chat.str_save_failed')));
    }
    OXLoading.dismiss();
  }
}

/// make hero better when slide out
class HeroWidget extends StatefulWidget {
  const HeroWidget({
    required this.child,
    required this.tag,
    required this.slidePagekey,
    this.slideType = SlideType.onlyImage,
  });
  final Widget child;
  final SlideType slideType;
  final Object tag;
  final GlobalKey<ExtendedImageSlidePageState> slidePagekey;
  @override
  _HeroWidgetState createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  RectTween? _rectTween;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      createRectTween: (Rect? begin, Rect? end) {
        _rectTween = RectTween(begin: begin, end: end);
        return _rectTween!;
      },
      // make hero better when slide out
      flightShuttleBuilder: (BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext) {
        // make hero more smoothly
        final Hero hero = (flightDirection == HeroFlightDirection.pop
            ? fromHeroContext.widget
            : toHeroContext.widget) as Hero;
        if (_rectTween == null) {
          return hero;
        }

        if (flightDirection == HeroFlightDirection.pop) {
          final bool fixTransform = widget.slideType == SlideType.onlyImage &&
              (widget.slidePagekey.currentState!.offset != Offset.zero ||
                  widget.slidePagekey.currentState!.scale != 1.0);

          final Widget toHeroWidget = (toHeroContext.widget as Hero).child;
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext buildContext, Widget? child) {
              Widget animatedBuilderChild = hero.child;

              // make hero more smoothly
              animatedBuilderChild = Stack(
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                children: <Widget>[
                  Opacity(
                    opacity: 1 - animation.value,
                    child: UnconstrainedBox(
                      child: SizedBox(
                        width: _rectTween!.begin!.width,
                        height: _rectTween!.begin!.height,
                        child: toHeroWidget,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: animation.value,
                    child: animatedBuilderChild,
                  )
                ],
              );

              // fix transform when slide out
              if (fixTransform) {
                final Tween<Offset> offsetTween = Tween<Offset>(
                    begin: Offset.zero,
                    end: widget.slidePagekey.currentState!.offset);

                final Tween<double> scaleTween = Tween<double>(
                    begin: 1.0, end: widget.slidePagekey.currentState!.scale);
                animatedBuilderChild = Transform.translate(
                  offset: offsetTween.evaluate(animation),
                  child: Transform.scale(
                    scale: scaleTween.evaluate(animation),
                    child: animatedBuilderChild,
                  ),
                );
              }

              return animatedBuilderChild;
            },
          );
        }
        return hero.child;
      },
      child: widget.child,
    );
  }
}
