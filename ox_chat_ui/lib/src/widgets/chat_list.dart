import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../ox_chat_ui.dart';
import '../models/bubble_rtl_alignment.dart';
import 'patched_sliver_animated_list.dart';
import 'state/inherited_chat_theme.dart';
import 'state/inherited_user.dart';
import 'typing_indicator.dart';

/// Animated list that handles automatic animations and pagination.
class ChatList extends StatefulWidget {
  /// Creates a chat list widget.
  const ChatList({
    super.key,
    this.scrollToAnchorMsgAction,
    this.bottomWidget,
    required this.bubbleRtlAlignment,
    this.isLastPage,
    required this.itemBuilder,
    required this.items,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.onEndReached,
    this.onEndReachedThreshold,
    required this.scrollController,
    this.scrollPhysics,
    this.typingIndicatorOptions,
    required this.useTopSafeAreaInset,
  });

  final VoidCallback? scrollToAnchorMsgAction;

  /// A custom widget at the bottom of the list.
  final Widget? bottomWidget;

  /// Used to set alignment of typing indicator.
  /// See [BubbleRtlAlignment].
  final BubbleRtlAlignment bubbleRtlAlignment;

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
  bool _isShowNextPageLoading = false;
  bool _isNextPageLoading = false;
  final GlobalKey<PatchedSliverAnimatedListState> _listKey =
      GlobalKey<PatchedSliverAnimatedListState>();
  late List<Object> _oldData = List.from(widget.items);

  bool _isAtBottom = false;
  bool _isFirstLaunch = true;

  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();

    didUpdateWidget(widget);
    _isFirstLaunch = false;
  }

  @override
  void didUpdateWidget(covariant ChatList oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calculateDiffs(oldWidget.items);
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
          loadingIfNeeded(notification);
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
              padding: const EdgeInsets.only(bottom: 4),
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
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 4),
              sliver: PatchedSliverAnimatedList(
                findChildIndexCallback: (Key key) {
                  if (key is ValueKey<Object>) {
                    final newIndex = widget.items.indexWhere(
                      (v) => _valueKeyForItem(v) == key,
                    );
                    if (newIndex != -1) {
                      return newIndex;
                    }
                  }
                  return null;
                },
                initialItemCount: widget.items.length,
                key: _listKey,
                itemBuilder: (_, index, animation) =>
                    _newMessageBuilder(index, animation),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: 16,
              ),
              sliver: SliverToBoxAdapter(
                child: SizeTransition(
                  axisAlignment: 1,
                  sizeFactor: _animation,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      height: 32,
                      width: 32,
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: _isShowNextPageLoading
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  void _calculateDiffs(List<Object> oldList) async {
    final diffResult = calculateListDiff<Object>(
      oldList,
      widget.items,
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

    for (final update in diffResult.getUpdates(batch: false)) {
      update.when(
        insert: (pos, count) {
          _listKey.currentState?.insertItem(pos);
        },
        remove: (pos, count) {
          final item = oldList[pos];
          _listKey.currentState?.removeItem(
            pos,
            (_, animation) => _removedMessageBuilder(item, animation),
          );
        },
        change: (pos, payload) {},
        move: (from, to) {},
      );
    }
    _scrollToBottomIfNeeded(oldList);

    _oldData = List.from(widget.items);
  }

  Widget _newMessageBuilder(int index, Animation<double> animation) {
    try {
      final item = _oldData[index];
      
      return SizeTransition(
        key: _valueKeyForItem(item),
        axisAlignment: -1,
        sizeFactor: animation.drive(CurveTween(curve: Curves.easeOutQuad)),
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

  // Hacky solution to reconsider.
  void _scrollToBottomIfNeeded(List<Object> oldList) {
    if (!_isFirstLaunch && !shouldScrollToBottom(oldList)) return ;
    final scrollToAnchorMsgAction = widget.scrollToAnchorMsgAction;
    if (_isFirstLaunch && scrollToAnchorMsgAction != null) {
      scrollToAnchorMsgAction();
    } else {
      scrollToBottom();
    }
  }

  void scrollToBottom() {
    if (_isFirstLaunch) {
      // if (mounted) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) async {
      //     widget.scrollController.jumpTo(0);
      //   });
      // }
    } else {
      if (widget.scrollController.hasClients) {
        widget.scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeInQuad,
        );
      }
    }
  }

  bool shouldScrollToBottom(List<Object> oldList) {
    final oldItem = oldList.last;
    final item = widget.items.last;
    var hasNewMessage = false;
    if (oldItem is Map<String, Object> && item is Map<String, Object>) {
      final oldMessage = oldItem['message']! as types.Message;
      final message = item['message']! as types.Message;
      hasNewMessage = oldMessage.id != message.id;
    }

    if (hasNewMessage && _isAtBottom) {
      return true;
    }

    return false;
  }

  void updateBottomFlag(ScrollNotification notification) {
    final bottomOffset = 100.0;
    _isAtBottom = notification.metrics.pixels >= notification.metrics.maxScrollExtent - bottomOffset;
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

  void loadingIfNeeded(ScrollNotification notification) {

    if (widget.items.isEmpty || widget.onEndReached == null || widget.isLastPage == true) return ;

    final loadingOffset = 50;
    final isTryLoading = notification.metrics.pixels >= notification.metrics.maxScrollExtent - loadingOffset;
    if (!isTryLoading) return ;

    final tryShowNextPageLoading = () {
      if (!_isShowNextPageLoading) {
        setState(() {
          _isShowNextPageLoading = true;
        });
      }
    };

    final tryDoLoadingAction = () {
      if (_isScrolling) return ;
      if (_isNextPageLoading) return ;
      _isNextPageLoading = true;

      widget.onEndReached!().whenComplete(() {
        setState(() {
          _isShowNextPageLoading = false;
          _isNextPageLoading = false;
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
