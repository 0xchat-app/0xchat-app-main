import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'platform/platform.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

enum PressType {
  longPress,
  singleClick,
}

enum PreferredPosition {
  top,
  bottom,
}

class CustomPopupMenuController extends ChangeNotifier {
  bool menuIsShowing = false;

  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }
}

Rect _menuRect = Rect.zero;

class CustomPopupMenu extends StatefulWidget {
  CustomPopupMenu({
    required this.child,
    required this.menuBuilder,
    required this.pressType,
    this.controller,
    this.arrowColor = const Color(0xFF4C4C4C),
    this.showArrow = true,
    this.barrierColor = Colors.black12,
    this.arrowSize = 10.0,
    this.horizontalMargin = 10.0,
    this.verticalMargin = 10.0,
    this.position,
    this.menuOnChange,
    this.enablePassEvent = true,
  });

  final Widget child;
  final PressType pressType;
  final bool showArrow;
  final Color arrowColor;
  final Color barrierColor;
  final double horizontalMargin;
  final double verticalMargin;
  final double arrowSize;
  final CustomPopupMenuController? controller;
  final Widget Function() menuBuilder;
  final PreferredPosition? position;
  final void Function(bool)? menuOnChange;

  /// Pass tap event to the widgets below the mask.
  /// It only works when [barrierColor] is transparent.
  final bool enablePassEvent;

  @override
  _CustomPopupMenuState createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  RenderBox? _childBox;
  RenderBox? _parentBox;
  OverlayEntry? _overlayEntry;
  CustomPopupMenuController? _controller;
  bool _canResponse = true;

  void _showMenu() {
    final Widget arrow = ClipPath(
      clipper: _ArrowClipper(),
      child: Container(
        width: widget.arrowSize,
        height: widget.arrowSize,
        color: widget.arrowColor,
      ),
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final Widget menu = Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: _parentBox!.size.width - 2 * widget.horizontalMargin,
              minWidth: 0,
            ),
            child: CustomMultiChildLayout(
              delegate: _MenuLayoutDelegate(
                anchorSize: _childBox!.size,
                anchorOffset: _childBox!.localToGlobal(
                  Offset(-widget.horizontalMargin, 0),
                ),
                verticalMargin: widget.verticalMargin,
              ),
              children: <Widget>[
                if (widget.showArrow)
                  LayoutId(
                    id: _MenuLayoutId.arrow,
                    child: arrow,
                  ),
                if (widget.showArrow)
                  LayoutId(
                    id: _MenuLayoutId.downArrow,
                    child: Transform.rotate(
                      angle: math.pi,
                      child: arrow,
                    ),
                  ),
                LayoutId(
                  id: _MenuLayoutId.content,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        child: widget.menuBuilder(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        return Listener(
          behavior: widget.enablePassEvent
              ? HitTestBehavior.translucent
              : HitTestBehavior.opaque,
          onPointerDown: (PointerDownEvent event) {
            final offset = event.localPosition;
            // If tap position in menu
            if (_menuRect.contains(
                Offset(offset.dx - widget.horizontalMargin, offset.dy))) {
              return;
            }
            _controller?.hideMenu();
            // When [enablePassEvent] works and we tap the [child] to [hideMenu],
            // but the passed event would trigger [showMenu] again.
            // So, we use time threshold to solve this bug.
            _canResponse = false;
            Future.delayed(Duration(milliseconds: 300))
                .then((_) => _canResponse = true);
          },
          child: widget.barrierColor == Colors.transparent
              ? menu
              : Container(
                  color: widget.barrierColor,
                  child: menu,
                ),
        );
      },
    );
    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void _updateView() {
    final menuIsShowing = _controller?.menuIsShowing ?? false;
    widget.menuOnChange?.call(menuIsShowing);
    if (menuIsShowing) {
      _showMenu();
    } else {
      _hideMenu();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    if (_controller == null) _controller = CustomPopupMenuController();
    _controller?.addListener(_updateView);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        _childBox = context.findRenderObject() as RenderBox?;
        _parentBox =
            Overlay.of(context).context.findRenderObject() as RenderBox?;
      }
    });
  }

  @override
  void dispose() {
    _hideMenu();
    _controller?.removeListener(_updateView);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: Colors.transparent,
      child: GestureDetector(
        // hoverColor: Colors.transparent,
        // focusColor: Colors.transparent,
        // splashColor: Colors.transparent,
        // highlightColor: Colors.transparent,
        child: widget.child,
        // onTap: () {
        //   if (widget.pressType == PressType.singleClick && _canResponse) {
        //     _controller?.showMenu();
        //   }
        // },
        onLongPress: () {
          if (widget.pressType == PressType.longPress && _canResponse) {
            FeedbackType type = FeedbackType.impact;
            Vibrate.feedback(type);
            _controller?.showMenu();
          }
        },
      ),
    );
    if (Platform.isIOS) {
      return child;
    } else {
      return WillPopScope(
        onWillPop: () {
          _hideMenu();
          return Future.value(true);
        },
        child: child,
      );
    }
  }
}

enum _MenuLayoutId {
  arrow,
  downArrow,
  content,
}

class _MenuLayoutDelegate extends MultiChildLayoutDelegate {
  _MenuLayoutDelegate({
    required this.anchorSize,
    required this.anchorOffset,
    required this.verticalMargin,
  });

  final Size anchorSize;
  final Offset anchorOffset;
  final double verticalMargin;

  @override
  void performLayout(Size size) {

    var contentSize = Size.zero;
    var arrowSize = Size.zero;
    final anchorCenterX = anchorOffset.dx + anchorSize.width / 2;
    final anchorTopY = anchorOffset.dy;
    final anchorBottomY = anchorTopY + anchorSize.height;

    // Prepare widget size
    if (hasChild(_MenuLayoutId.content)) {
      contentSize = layoutChild(
        _MenuLayoutId.content,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_MenuLayoutId.arrow)) {
      arrowSize = layoutChild(
        _MenuLayoutId.arrow,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_MenuLayoutId.downArrow)) {
      layoutChild(
        _MenuLayoutId.downArrow,
        BoxConstraints.loose(size),
      );
    }

    // Position type priority
    // 1. Top Up
    // 2. Top Down(Long message)
    // 3. Bottom Up(Long message)
    // 4. Bottom Down
    // 5. Center Up(Long message)
    final bottomMaxY = size.height - 50.px - Adapt.bottomSafeAreaHeightByKeyboard;
    final menuContentHeight = contentSize.height + arrowSize.height + verticalMargin;
    final isLongMessage = anchorSize.height > menuContentHeight * 2;
    bool? isTop;
    bool isUp;
    if (anchorTopY - menuContentHeight > Adapt.topSafeAreaHeight) {
      // Top Up
      isTop = true;
      isUp = true;
    } else if (isLongMessage
        && anchorTopY > Adapt.topSafeAreaHeight) {
      // Top Down
      isTop = true;
      isUp = false;
    } else if (isLongMessage
        && anchorBottomY < bottomMaxY
        && anchorBottomY - menuContentHeight > Adapt.topSafeAreaHeight) {
      // Bottom Up
      isTop = false;
      isUp = true;
    } else if (!isLongMessage
        || anchorBottomY + menuContentHeight < bottomMaxY) {
      // Bottom Down
      isTop = false;
      isUp = false;
    } else {
      // Center Up
      isTop = null;
      isUp = true;
    }

    // Prepare position
    final isTopDown = isTop == true && !isUp;
    final isBottomUp = isTop == false && isUp;
    final positionExtension = isTopDown || isBottomUp ? 30.px : 0.0;
    var menuPositionX = anchorCenterX - contentSize.width / 2;
    final arrowPositionX = anchorCenterX - arrowSize.width / 2;
    var menuPositionY, arrowPositionY = 0.0;
    // Top or Bottom
    if (isTop == true) {
      menuPositionY = anchorTopY;
    } else if (isTop == false) {
      menuPositionY = anchorBottomY;
    } else {
      menuPositionY = size.height / 2;
    }
    arrowPositionY = menuPositionY;
    // Up or Down
    if (isUp) {
      menuPositionY -= menuContentHeight + positionExtension;
      arrowPositionY -= arrowSize.height + verticalMargin + positionExtension;
    } else {
      menuPositionY += arrowSize.height + verticalMargin + positionExtension;
      arrowPositionY += verticalMargin + positionExtension;
    }
    // Adjust menuPositionX based on screen edges
    if (menuPositionX < 0 && anchorCenterX <= size.width / 2) {
      menuPositionX = 0; // Align with the left edge of the screen
    } else if (menuPositionX + contentSize.width > size.width && anchorCenterX > size.width / 2) {
      menuPositionX = size.width - contentSize.width; // Align with the right edge of the screen
    }

    // Layout child widget
    if (hasChild(_MenuLayoutId.content)) {
      positionChild(_MenuLayoutId.content, Offset(menuPositionX, menuPositionY));
    }
    _menuRect = Rect.fromLTWH(
      menuPositionX,
      menuPositionY,
      contentSize.width,
      contentSize.height,
    );
    if (hasChild(_MenuLayoutId.downArrow)) {
      positionChild(
        _MenuLayoutId.downArrow,
        isUp
            ? Offset(arrowPositionX, arrowPositionY - 0.1)
            : Offset(-100, 0),
      );
    }
    if (hasChild(_MenuLayoutId.arrow)) {
      positionChild(
        _MenuLayoutId.arrow,
        !isUp
            ? Offset(arrowPositionX, arrowPositionY + 0.1)
            : Offset(-100, 0),
      );
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
