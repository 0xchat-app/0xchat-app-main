import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../ox_chat_ui.dart';
import 'patched_sliver_animated_list.dart';
import 'state/inherited_chat_theme.dart';

/// Animated list that handles automatic animations and pagination.
class ChatList extends StatefulWidget {
  /// Creates a chat list widget.
  const ChatList({
    super.key,
    this.scrollToAnchorMsgAction,
    this.bottomWidget,
    required this.bubbleRtlAlignment,
    this.isFirstPage,
    this.isLastPage,
    required this.itemBuilder,
    required this.items,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.onEndReached,
    this.onEndReachedThreshold,
    this.onHeadReached,
    required this.scrollController,
    this.scrollPhysics,
    this.typingIndicatorOptions,
    required this.useTopSafeAreaInset,
  });

  final Future Function()? scrollToAnchorMsgAction;

  /// A custom widget at the bottom of the list.
  final Widget? bottomWidget;

  /// Used to set alignment of typing indicator.
  /// See [BubbleRtlAlignment].
  final BubbleRtlAlignment bubbleRtlAlignment;

  final bool? isFirstPage;

  /// Used for pagination (infinite scroll) together with [onEndReached].
  /// When true, indicates that there are no more pages to load and
  /// pagination will not be triggered.
  final bool? isLastPage;

  /// Item builder.
  final Widget Function(Object, int? index) itemBuilder;

  /// Items to build.
  final List<Object> items;

  /// Used for pagination (infinite scroll). Called when user scrolls
  /// to the very end of the list (minus [onEndReachedThreshold]).
  final Future<void> Function()? onEndReached;

  final Future<void> Function()? onHeadReached;

  /// A representation of how a [ScrollView] should dismiss the on-screen keyboard.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Used for pagination (infinite scroll) together with [onEndReached].
  /// Can be anything from 0 to 1, where 0 is immediate load of the next page
  /// as soon as scroll starts, and 1 is load of the next page only if scrolled
  /// to the very end of the list. Default value is 0.75, e.g. start loading
  /// next page when scrolled through about 3/4 of the available content.
  final double? onEndReachedThreshold;

  /// Scroll controller for the main [CustomScrollView]. Also used to auto scroll
  /// to specific messages.
  final ScrollController scrollController;

  /// Determines the physics of the scroll view.
  final ScrollPhysics? scrollPhysics;

  /// Used to build typing indicator according to options.
  /// See [TypingIndicatorOptions].
  final TypingIndicatorOptions? typingIndicatorOptions;

  /// Whether to use top safe area inset for the list.
  final bool useTopSafeAreaInset;

  @override
  State<ChatList> createState() => _ChatListState();
}

/// [ChatList] widget state.
class _ChatListState extends State<ChatList>
    with SingleTickerProviderStateMixin {
  late final Animation<double> _animation = CurvedAnimation(
    curve: Curves.easeOutQuad,
    parent: _controller,
  );
  late final AnimationController _controller = AnimationController(vsync: this)
    ..duration = Duration.zero
    ..forward();

  bool _indicatorOnScrollStatus = false;
  bool _isShowBeforePageLoading = false;
  bool _isBeforePageLoading = false;
  bool _isShowAfterPageLoading = false;
  bool _isAfterPageLoading = false;
  final GlobalKey<PatchedSliverAnimatedListState> _listKey =
      GlobalKey<PatchedSliverAnimatedListState>();

  bool _isAtBottom = true;

  bool _isScrolling = false;

  List<Object> bodyItems = [];
  List<Object> headerItems = [];

  List<Object> get items => [...headerItems, ...bodyItems];

  final headerWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    bodyItems = [...widget.items];
    if (widget.scrollToAnchorMsgAction != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await widget.scrollToAnchorMsgAction?.call();
      });
    }
  }

  @override
  void didUpdateWidget(covariant ChatList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items != widget.items) {
      final oldList = [...headerItems, ...bodyItems,];
      final newList = [...widget.items];
      _calculateDiffs(oldList, newList);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          updateBottomFlag(notification);
          updateIndicatorStatus(notification);
          updateScrollingFlag(notification);
          loadingBeforeMessageIfNeeded(notification);
          loadingAfterMessageIfNeeded(notification);
          return false;
        },
        child: CustomScrollView(
          controller: widget.scrollController,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          physics: widget.scrollPhysics,
          reverse: true,
          slivers: [
            if (widget.bottomWidget != null)
              SliverToBoxAdapter(child: widget.bottomWidget),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              sliver: SliverToBoxAdapter(
                child: widget.typingIndicatorOptions?.customTypingIndicator ??
                    TypingIndicator(
                      bubbleAlignment: widget.bubbleRtlAlignment,
                      options: widget.typingIndicatorOptions!,
                      showIndicator: (widget
                              .typingIndicatorOptions!.typingUsers.isNotEmpty &&
                          !_indicatorOnScrollStatus),
                    ),
              ),
            ),
            buildHeaderListView(),
            buildBodyListView(),
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: 16,
              ),
              sliver: SliverToBoxAdapter(
                child: SizeTransition(
                  axisAlignment: 1,
                  sizeFactor: _animation,
                  child: Center(
                    child: buildLoadingWidget(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildBodyListView() =>
      SliverList(
        delegate: SliverChildBuilderDelegate(
              (_, index) => _newMessageBuilder(bodyItems[index], index + headerItems.length),
          childCount: bodyItems.length,
          findChildIndexCallback: (Key key) {
            if (key is ValueKey<Object>) {
              final newIndex = bodyItems.indexWhere(
                    (v) => _valueKeyForItem(v) == key,
              );
              if (newIndex != -1) {
                return newIndex;
              }
            }
            return null;
          },
        ),
      );

  Widget buildHeaderListView() =>
      SliverVisibility(
        visible: false,
        maintainState: true,
        sliver: SliverToBoxAdapter(
          child: NotificationListener<SizeChangedLayoutNotification>(
            onNotification: (notification) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (headerItems.isEmpty) return ;
                insertHeaderMessage();
              });
              return true;
            },
            child: SizeChangedLayoutNotifier(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                key: headerWidgetKey,
                shrinkWrap: true,
                reverse: true,
                itemCount: headerItems.length,
                itemBuilder: (context, index) => _newMessageBuilder(headerItems[index], index),
              ),
            ),
          ),
        ),
      );

  void _calculateDiffs(List<Object> oldList, List<Object> newList) async {
    final newHeaderItems = [...headerItems];
    final newBodyItems = [...bodyItems];

    final diffResult = calculateListDiff<Object>(
      oldList,
      newList,
      equalityChecker: (item1, item2) {
        if (item1 is Map<String, Object> && item2 is Map<String, Object>) {
          final message1 = item1['message']! as types.Message;
          final message2 = item2['message']! as types.Message;

          return message1.id == message2.id;
        } else {
          return item1 == item2;
        }
      },
    );

    for (final update in diffResult.getUpdatesWithData()) {
      update.when(
        insert: (pos, data) {
          _listKey.currentState?.insertItem(pos);
          if (pos <= headerItems.length) {
            newHeaderItems.insert(pos, data);
          } else {
            newBodyItems.insert(pos - headerItems.length, data);
          }
        },
        remove: (pos, data) {
          final item = oldList[pos];
          _listKey.currentState?.removeItem(
            pos,
            (_, animation) => _removedMessageBuilder(item, animation),
          );
          if (pos <= headerItems.length) {
            newHeaderItems.removeAt(pos);
          } else {
            newBodyItems.removeAt(pos - headerItems.length);
          }
        },
        change: (pos, oldData, newData) {},
        move: (from, to, data) {},
      );
    }

    if (oldList.isEmpty) {
      headerItems = [];
      bodyItems = [...newList];
    } else {
      headerItems = newHeaderItems;
      bodyItems = newBodyItems;
    }
  }

  void insertHeaderMessage() {
    final renderBox = headerWidgetKey.currentContext?.findRenderObject();
    if (renderBox is! RenderBox) return ;

    final immutableHeaderItems = [...headerItems];
    headerItems.clear();

    final size = renderBox.size;
    if (size.height < 1) return ;

    if (immutableHeaderItems.length == 1 && widget.isFirstPage == true && shouldScrollToBottom()) {
      scrollToBottom();
    } else {
      final position = widget.scrollController.position;
      position.correctPixels(size.height + position.pixels);
    }
    setState(() {
      bodyItems.insertAll(0, immutableHeaderItems);
    });
  }

  Widget buildLoadingWidget() => Container(
      alignment: Alignment.center,
      height: 32,
      width: 32,
      child: SizedBox(
        height: 16,
        width: 16,
        child: _isShowBeforePageLoading
            ? CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          strokeWidth: 1.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            InheritedChatTheme.of(context)
                .theme
                .primaryColor,
          ),
        )
            : null,
      ),
    );

  Widget _newMessageBuilder(Object item, int index) {
    try {
      return SizedBox(
        key: _valueKeyForItem(item),
        child: widget.itemBuilder(item, index),
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  Widget _removedMessageBuilder(Object item, Animation<double> animation) =>
      SizeTransition(
        key: _valueKeyForItem(item),
        axisAlignment: -1,
        sizeFactor: animation.drive(CurveTween(curve: Curves.easeInQuad)),
        child: FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeInQuad)),
          child: widget.itemBuilder(item, null),
        ),
      );

  void scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeInQuad,
      );
    }
  }

  bool shouldScrollToBottom() => _isAtBottom;

  void updateBottomFlag(ScrollNotification notification) {
    final bottomOffset = 100.0;
    _isAtBottom = notification.metrics.pixels < bottomOffset;
  }

  void updateIndicatorStatus(ScrollNotification notification) {
    if (notification.metrics.pixels > 10.0 && !_indicatorOnScrollStatus) {
      setState(() {
        _indicatorOnScrollStatus = !_indicatorOnScrollStatus;
      });
    } else if (notification.metrics.pixels == 0.0 &&
        _indicatorOnScrollStatus) {
      setState(() {
        _indicatorOnScrollStatus = !_indicatorOnScrollStatus;
      });
    }
  }

  void updateScrollingFlag(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _isScrolling = true;
    } else if (notification is ScrollEndNotification) {
      _isScrolling = false;
    }
  }

  void loadingBeforeMessageIfNeeded(ScrollNotification notification) {

    if (items.isEmpty || widget.onEndReached == null || widget.isLastPage == true) return ;

    final loadingOffset = 50;
    final isTryLoading = notification.metrics.pixels >= notification.metrics.maxScrollExtent - loadingOffset;
    if (!isTryLoading) return ;

    final tryShowNextPageLoading = () {
      if (!_isShowBeforePageLoading) {
        setState(() {
          _isShowBeforePageLoading = true;
        });
      }
    };

    final tryDoLoadingAction = () {
      if (_isScrolling) return ;
      if (_isBeforePageLoading) return ;
      _isBeforePageLoading = true;

      widget.onEndReached?.call().whenComplete(() {
        setState(() {
          _isShowBeforePageLoading = false;
          _isBeforePageLoading = false;
        });
      });
    };

    tryShowNextPageLoading();
    tryDoLoadingAction();
  }

  void loadingAfterMessageIfNeeded(ScrollNotification notification) {

    if (items.isEmpty || widget.onHeadReached == null) return ;

    final loadingOffset = 30;
    final isTryLoading = notification.metrics.pixels < loadingOffset;
    if (!isTryLoading) return ;

    final tryShowNextPageLoading = () {
      if (!_isShowAfterPageLoading) {
        setState(() {
          _isShowAfterPageLoading = true;
        });
      }
    };

    final tryDoLoadingAction = () {
      if (_isScrolling) return ;
      if (_isAfterPageLoading) return ;
      _isAfterPageLoading = true;

      widget.onHeadReached?.call().whenComplete(() {
        setState(() {
          _isShowAfterPageLoading = false;
          _isAfterPageLoading = false;
        });
      });
    };

    tryShowNextPageLoading();
    tryDoLoadingAction();
  }

  Key? _valueKeyForItem(Object item) =>
      _mapMessage(item, (message) => ValueKey(message.id));

  T? _mapMessage<T>(Object maybeMessage, T Function(types.Message) f) {
    if (maybeMessage is Map<String, Object>) {
      return f(maybeMessage['message'] as types.Message);
    }
    return null;
  }
}
