
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class FlexibleTabBarViewNotification extends Notification {
  FlexibleTabBarViewNotification(this.size);
  Size? size;
}

mixin FlexibleTabBarViewMixin<T extends StatefulWidget> on State<T> {

  Size? _oldSize;

  void _notifySize() {
    if (!mounted) return ;
    final size = context.size;
    if (_oldSize != size) {
      _oldSize = size;
      FlexibleTabBarViewNotification(size).dispatch(context);
    }
  }

  @mustCallSuper
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _notifySize());
    return SizedBox();
  }
}

/// Support TabBar components of different height children, all children loaded ahead of time
/// * Currently, the number of tabs cannot be changed
class FlexibleTabBarView extends StatefulWidget {
  final List<Widget> children;
  final TabController? tabController;

  const FlexibleTabBarView({
    Key? key,
    required this.children,
    this.tabController,
  }) : super(key: key);

  @override
  _FlexibleTabBarViewState createState() => _FlexibleTabBarViewState();
}

class _FlexibleTabBarViewState extends State<FlexibleTabBarView> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  late List<double> _heights;

  late List<Widget> _children;
  late List<Widget> _childrenWithKey;

  int? _currentIndex;
  int _currentPage = 0;
  int _warpUnderwayCount = 0;

  double get _currentHeight => _heights[_currentPage];

  @override
  void initState() {
    _heights = widget.children.map((e) => 0.0).toList();
    super.initState();
    _tabController = (widget.tabController ?? TabController(length: widget.children.length, vsync: this))
      ..addListener(tabControllerOnChange);
    _tabController.animation!.addListener(_handleTabControllerAnimationTick);
    _updateChildren();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentIndex = _tabController.index;
    _pageController = PageController(initialPage: _currentIndex ?? 0);
  }

  @override
  void didUpdateWidget(FlexibleTabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children != oldWidget.children && _warpUnderwayCount == 0)
      _updateChildren();
  }

  void dispose() {
    _tabController.animation!.removeListener(_handleTabControllerAnimationTick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeInOutCubic,
      duration: const Duration(milliseconds: 100),
      tween: Tween<double>(begin: _heights[0], end: _currentHeight),
      builder: (context, value, child) => SizedBox(height: value, child: child),
      child: _buildTabBarView(),
    );
  }

  Widget _buildTabBarView() {
    final axisDirection = AxisDirection.right;
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scrollable(
        axisDirection: axisDirection,
        controller: _pageController,
        physics: PageScrollPhysics().applyTo(AlwaysScrollableScrollPhysics()),
        viewportBuilder: (BuildContext context, ViewportOffset position) {
          return Viewport(
            cacheExtent: widget.children.length - 1,
            cacheExtentStyle: CacheExtentStyle.viewport,
            axisDirection: axisDirection,
            offset: position,
            slivers: <Widget>[
              SliverFillViewport(
                viewportFraction: _pageController.viewportFraction,
                delegate: SliverChildListDelegate(_buildSizeReportingChildren()),
              ),
            ],
          );
        },
      )
    );
  }

  List<Widget> _buildSizeReportingChildren() {
    return widget.children
        .asMap()
        .map(
          (index, child) => MapEntry(
        index,
        OverflowBox(
          minHeight: 0,
          maxHeight: double.infinity,
          alignment: Alignment.topCenter,
          child: NotificationListener<FlexibleTabBarViewNotification>(
            onNotification: (notification) {
              setState(() => _heights[index] = notification.size?.height ?? 0);
              return true;
            },
            child: Align(child: child),
          ),
        ),
      ),
    ).values.toList();
  }


  /** Action **/
  /// update
  void _updateChildren() {
    _children = widget.children;
    _childrenWithKey = KeyedSubtree.ensureUniqueKeysForList(widget.children);
  }

  void tabControllerOnChange() {
    final _newPage = widget.tabController!.index;
    if (_currentPage != _newPage) {
      setState(() => _currentPage = _newPage);
    }
  }

  void _handleTabControllerAnimationTick() {
    if (_warpUnderwayCount > 0 || !_tabController.indexIsChanging)
      return; // This widget is driving the controller's animation.

    if (_tabController.index != _currentIndex) {
      _currentIndex = _tabController.index;
      _warpToCurrentIndex();
    }
  }

  Future<void> _warpToCurrentIndex() async {
    if (!mounted)
      return Future<void>.value();

    if (_pageController.page == _currentIndex!.toDouble())
      return Future<void>.value();

    final int previousIndex = _tabController.previousIndex;
    if ((_currentIndex! - previousIndex).abs() == 1) {
      _warpUnderwayCount += 1;
      await _pageController.animateToPage(_currentIndex!, duration: kTabScrollDuration, curve: Curves.ease);
      _warpUnderwayCount -= 1;
      return Future<void>.value();
    }

    assert((_currentIndex! - previousIndex).abs() > 1);
    final int initialPage = _currentIndex! > previousIndex
        ? _currentIndex! - 1
        : _currentIndex! + 1;
    final List<Widget> originalChildren = _childrenWithKey;
    setState(() {
      _warpUnderwayCount += 1;

      _childrenWithKey = List<Widget>.from(_childrenWithKey, growable: false);
      final Widget temp = _childrenWithKey[initialPage];
      _childrenWithKey[initialPage] = _childrenWithKey[previousIndex];
      _childrenWithKey[previousIndex] = temp;
    });
    _pageController.jumpToPage(initialPage);

    await _pageController.animateToPage(_currentIndex!, duration: kTabScrollDuration, curve: Curves.ease);
    if (!mounted)
      return Future<void>.value();
    setState(() {
      _warpUnderwayCount -= 1;
      if (widget.children != _children) {
        _updateChildren();
      } else {
        _childrenWithKey = originalChildren;
      }
    });
  }

  // Called when the PageView scrolls
  bool _handleScrollNotification(ScrollNotification notification) {
    if (_warpUnderwayCount > 0)
      return false;

    if (notification.depth != 0)
      return false;

    _warpUnderwayCount += 1;
    if (notification is ScrollUpdateNotification && !_tabController.indexIsChanging) {
      if ((_pageController.page! - _tabController.index).abs() > 1.0) {
        _tabController.index = _pageController.page!.floor();
        _currentIndex =_tabController.index;
      }
      _tabController.offset = (_pageController.page! - _tabController.index).clamp(-1.0, 1.0);
    } else if (notification is ScrollEndNotification) {
      _tabController.index = _pageController.page!.round();
      _currentIndex = _tabController.index;
      if (!_tabController.indexIsChanging)
        _tabController.offset = (_pageController.page! - _tabController.index).clamp(-1.0, 1.0);
    }
    _warpUnderwayCount -= 1;

    return false;
  }
}