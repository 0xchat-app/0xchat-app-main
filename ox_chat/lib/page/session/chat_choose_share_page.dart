import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/utils/chat_session_utils.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/widget/share_item_info.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_chat/utils/chat_send_invited_template_helper.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:grouped_list/grouped_list.dart';

class ChatChooseSharePage extends StatefulWidget {
  final Key? key;
  final String msg;

  ChatChooseSharePage({this.key, required this.msg}) : super(key: key);

  @override
  _ChatChooseSharePageState createState() => _ChatChooseSharePageState();
}

class _ChatChooseSharePageState extends State<ChatChooseSharePage> with ShareItemInfoMixin {
  List<ShareSearchGroup> _recentChatList = [];
  List<ShareSearchGroup> _showChatList = [];
  String receiverPubkey = '';
  ValueNotifier<bool> _isClear = ValueNotifier(false);
  TextEditingController _controller = TextEditingController();
  Map<String, List<String>> _groupMembersCache = {};
  String _ShareToName = 'xxx';
  final maxItemsCount = 3;
  Map<ShareSearchType, bool> _showItemAll = {};

  @override
  void initState() {
    super.initState();
    _fetchListAsync();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        _isClear.value = true;
      } else {
        _isClear.value = false;
      }
    });
  }

  Future<void> _fetchListAsync() async {
    List<ChatSessionModel> sessions = OXChatBinding.sharedInstance.sessionList;
    sessions.sort((session1, session2) {
      var session2CreatedTime = session2.createTime;
      var session1CreatedTime = session1.createTime;
      return session2CreatedTime.compareTo(session1CreatedTime);
    });
    ShareSearchGroup searchGroup =
        ShareSearchGroup(title: 'str_recent_chats'.localized(), type: ShareSearchType.recentChats, items: sessions);
    _recentChatList.add(searchGroup);
    _showChatList = _recentChatList;
    _getGroupMembers(sessions);
    if (this.mounted) setState(() {});
  }

  void _getGroupMembers(List<ChatSessionModel> list) async {
    list.forEach((element) async {
      if (element.chatType == ChatType.chatGroup) {
        final groupId = element.groupId ?? '';
        List<UserDBISAR> groupList = await Groups.sharedInstance.getAllGroupMembers(groupId);
        List<String> avatars = groupList.map((element) => element.picture ?? '').toList();
        avatars.removeWhere((element) => element.isEmpty);
        _groupMembersCache[groupId] = avatars;
      }
    });
    updateStateView(_groupMembersCache);
  }

  String buildTitle() {
    return '${Localized.text('ox_chat.select_chat')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: buildTitle(),
        // actions: [
        //   IconButton(
        //     splashColor: Colors.transparent,
        //     highlightColor: Colors.transparent,
        //     icon: CommonImage(
        //       iconName: 'icon_done.png',
        //       width: 24.px,
        //       height: 24.px,
        //       useTheme: true,
        //     ),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: GroupedListView<ShareSearchGroup, dynamic>(
            elements: _showChatList,
            groupBy: (element) => element.title,
            padding: EdgeInsets.zero,
            groupHeaderBuilder: (element) {
              final hasMoreItems = element.items.length > maxItemsCount;
              return Container(
                width: double.infinity,
                height: Adapt.px(28),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        element.title,
                        style:
                            TextStyle(fontSize: Adapt.px(14), color: ThemeColor.color100, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemBuilder: (context, element) {
              // final items = showingItems(element);
              return Column(
                children: element.items.map((item) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildItemIcon(item),
                        SizedBox(width: 16.px),
                        buildItemName(item),
                      ],
                    ),
                    onTap: () {
                      buildSendPressed(item);
                    },
                  ).setPadding(EdgeInsets.only(bottom: 12.px));
                }).toList(),
              ).setPadding(EdgeInsets.only(top: 12.px));
              return SizedBox.shrink();
            },
            itemComparator: (item1, item2) => item1.title.compareTo(item2.title),
            useStickyGroupSeparators: false,
            floatingHeader: false,
          ),
        ),
      ],
    ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24)));
  }

  Widget _buildSearchBar() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ThemeColor.color180,
        ),
        height: Adapt.px(48),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
        margin: EdgeInsets.symmetric(vertical: Adapt.px(16)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w600,
                  height: Adapt.px(22.4) / Adapt.px(16),
                  color: ThemeColor.color0,
                ),
                decoration: InputDecoration(
                  icon: Container(
                    child: CommonImage(
                      iconName: 'icon_search.png',
                      width: Adapt.px(24),
                      height: Adapt.px(24),
                      fit: BoxFit.fill,
                    ),
                  ),
                  hintText: 'search'.localized(),
                  hintStyle: TextStyle(
                    fontSize: Adapt.px(16),
                    fontWeight: FontWeight.w400,
                    height: Adapt.px(22.4) / Adapt.px(16),
                    color: ThemeColor.color160,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: _handlingSearch,
              ),
            ),
            ValueListenableBuilder(
              builder: (context, value, child) {
                return _isClear.value
                    ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          setState(() {
                            _showChatList = _recentChatList;
                          });
                        },
                        child: CommonImage(
                          iconName: 'icon_textfield_close.png',
                          width: 16.px,
                          height: 16.px,
                        ),
                      )
                    : Container();
              },
              valueListenable: _isClear,
            ),
          ],
        ));
  }

  List<ChatSessionModel> showingItems(ShareSearchGroup group) {
    List<ChatSessionModel> temp = [];
    if (_showItemAll[group.type] ?? false) {
      return group.items;
    }
    if (group.items.length > maxItemsCount) {
      temp = group.items.sublist(0, maxItemsCount);
    }
    return temp;
  }

  void _handlingSearch(String searchQuery) {
    setState(() {
      if (searchQuery.isEmpty) {
        _showChatList = _recentChatList;
      } else {
        List<ShareSearchGroup> searchResult = [];
        List<UserDBISAR>? tempFriendList = loadChatFriendsWithSymbol(searchQuery);
        if (tempFriendList != null && tempFriendList.length > 0) {
          List<ChatSessionModel> friendSessions = [];
          tempFriendList.forEach((element) {
            LogUtil.e('Michael: -----element =${element.name}');
            friendSessions.add(ChatSessionModel(
              chatId: element.pubKey,
              chatType: ChatType.chatSingle,
              sender: element.pubKey,
            ));
          });
          searchResult.add(
            ShareSearchGroup(
                title: 'str_title_contacts'.localized(), type: ShareSearchType.friends, items: friendSessions),
          );
        }

        List<GroupDB>? tempGroupList = loadChatGroupWithSymbol(searchQuery);
        if (tempGroupList != null && tempGroupList.length > 0) {
          List<ChatSessionModel> groupSessions = [];
          tempGroupList.forEach((element) {
            groupSessions.add(ChatSessionModel(
              chatId: element.groupId,
              chatType: ChatType.chatGroup,
            ));
          });
          _getGroupMembers(groupSessions);
          searchResult.add(
            ShareSearchGroup(title: 'str_title_groups'.localized(), type: ShareSearchType.groups, items: groupSessions),
          );
        }
        List<ChannelDB>? tempChannelList = loadChatChannelsWithSymbol(searchQuery);
        if (tempChannelList != null && tempChannelList.length > 0) {
          List<ChatSessionModel> channelSessions = [];
          tempChannelList.forEach((element) {
            channelSessions.add(ChatSessionModel(
              chatId: element.channelId,
              chatType: ChatType.chatChannel,
            ));
          });
          searchResult.add(
            ShareSearchGroup(
                title: 'str_title_channels'.localized(), type: ShareSearchType.channels, items: channelSessions),
          );
        }

        _showChatList = searchResult;
      }
    });
  }

  buildSendPressed(ChatSessionModel sessionModel) {
    _ShareToName = ChatSessionUtils.getChatName(sessionModel);
    OXCommonHintDialog.show(context,
        title: Localized.text('ox_common.tips'),
        content: 'str_share_msg_confirm_content'.localized({r'${name}': _ShareToName}),
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context, false);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.str_share'),
              onTap: () async {
                OXNavigator.pop(context, true);

                OXLoading.show();
                final urlPreviewData = await WebURLHelper.getPreviewData(widget.msg, isShare: true);
                OXLoading.dismiss();

                final title = urlPreviewData.title ?? '';
                final link = urlPreviewData.link ?? '';
                if (title.isNotEmpty && link.isNotEmpty) {
                  ChatMessageSendEx.sendTemplateMessage(
                    receiverPubkey: sessionModel.chatId,
                    title: title,
                    subTitle: urlPreviewData.description ?? '',
                    icon: urlPreviewData.image?.url ?? '',
                    link: link,
                  );
                } else {
                  ChatMessageSendEx.sendTextMessageHandler(
                    sessionModel.chatId,
                    widget.msg,
                  );
                }

                OXNavigator.pop(context, true);
              }),
        ],
        isRowAction: true);
  }
}
