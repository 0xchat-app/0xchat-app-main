import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../utils/theme_color.dart';
import 'common_toast.dart';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

class CommonImageGallery extends StatefulWidget {
  final List<String> imageList;
  final String tag;
  final int initialPage;

  const CommonImageGallery(
      {required this.imageList, required this.tag, required this.initialPage});

  @override
  _CommonImageGalleryState createState() => _CommonImageGalleryState();
}

class _CommonImageGalleryState extends State<CommonImageGallery> {
  late ExtendedPageController _pageController;

  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();

  @override
  void initState() {
    super.initState();
    _pageController = ExtendedPageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          ExtendedImageSlidePage(
            key: slidePagekey,
            child: ExtendedImageGesturePageView.builder(
              controller: _pageController,
              itemCount: widget.imageList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onLongPress: _showBottomMenu,
                  onTap: () {
                    OXNavigator.pop(context);
                  },
                  child: HeroWidget(
                    child: ExtendedImage.network(
                      widget.imageList[index],
                      enableSlideOutPage: true,
                      onDoubleTap: (ExtendedImageGestureState state) {
                        final pointerDownPosition = state.pointerDownPosition;
                        final begin = state.gestureDetails!.totalScale!;
                        double end;
                        if (begin == 1) {
                          end = 3;
                        } else {
                          end = 1;
                        }
                        state.handleDoubleTap(
                            scale: end, doubleTapPosition: pointerDownPosition);
                      },
                    ),
                    tag: widget.imageList[index] + widget.tag,
                    slideType: SlideType.onlyImage,
                    slidePagekey: slidePagekey,
                  ),
                );
                // );
              },
              onPageChanged: (int index) {
                print('page changed to $index');
              },
              scrollDirection: Axis.horizontal,
            ),
            slideAxis: SlideAxis.both,
            slideType: SlideType.onlyImage,
            onSlidingPage: (state) {
              print('Sliding state: ${state.toString()}');
            },
          ),
          Positioned.directional(
            end: 16,
            textDirection: Directionality.of(context),
            bottom: 56,
            child: IconButton(
              icon: Icon(Icons.save_alt, color: Colors.white),
              onPressed: _widgetShotAndSave,
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => GestureDetector(
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
                      onTap: ()async {
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
    );
  }

  Future _widgetShotAndSave() async {
    if (widget.imageList.isEmpty) return;
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
