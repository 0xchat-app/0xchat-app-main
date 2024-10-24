import 'package:flutter/material.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/model/recent_search_user_isar.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/model/search_history_model_isar.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/page/session/search_chat_detail_page.dart';
import 'package:ox_chat/widget/search_result_item.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class SearchTabContentView extends StatefulWidget {
  final String searchQuery;
  final SearchType type;
  final List<dynamic> data;

  const SearchTabContentView({
    super.key,
    required this.data,
    required this.type,
    required this.searchQuery,
  });

  @override
  State<SearchTabContentView> createState() => _SearchTabContentViewState();
}

class _SearchTabContentViewState extends State<SearchTabContentView> with CommonStateViewMixin {

  @override
  void initState() {
    super.initState();
    _handleNoData();
  }

  @override
  void didUpdateWidget(covariant SearchTabContentView oldWidget) {
    setState(() {
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _handleNoData();
    return commonStateViewWidget(
      context,
      ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final item = widget.data[index];
          switch (widget.type) {
            case SearchType.chat:
              if (item is ChatMessage) {
                return SearchResultItem(
                  isUser: false,
                  searchQuery: widget.searchQuery,
                  avatarURL: item.picture,
                  title: item.name,
                  subTitle: item.subtitle,
                  onTap: () {
                    bool hasSingleRelatedRecord = item.relatedCount > 1;
                    if (hasSingleRelatedRecord) {
                      _gotoSearchChatDetailPage(item);
                    } else {
                      _gotoChatMessagePage(item);
                    }
                  },
                );
              }
              break;
            case SearchType.contact:
              if (item is UserDBISAR) {
                return SearchResultItem(
                  isUser: true,
                  searchQuery: widget.searchQuery,
                  avatarURL: item.picture,
                  title: item.name,
                  subTitle: item.about ?? '',
                  onTap: () => _gotoContactSession(item),
                );
              }
              break;
            case SearchType.group:
              if (item is GroupUIModel) {
                return SearchResultItem(
                  isUser: true,
                  searchQuery: widget.searchQuery,
                  avatarURL: item.picture,
                  title: item.name,
                  subTitle: item.about ?? '',
                  onTap: () => _gotoGroupSession(item),
                );
              }
              break;
            case SearchType.ecash:
              break;
            case SearchType.media:
              break;
            case SearchType.link:
              break;
            default:
              break;
          }
          return Container();
        },
        itemCount: widget.data.length,
        padding: EdgeInsets.symmetric(horizontal: 24.px),
      ),
    );
  }

  void _handleNoData() {
    if (widget.data.isEmpty) {
      updateStateView(CommonStateView.CommonStateView_NoData);
    } else {
      updateStateView(CommonStateView.CommonStateView_None);
    }
    setState(() {});
  }

  Future<void> _updateSearchHistory(UserDBISAR? userDB) async {
    final userPubkey = userDB?.pubKey;
    if (userPubkey != null) {
      await DBISAR.sharedInstance.saveToDB(RecentSearchUserISAR(pubKey: userPubkey));
    } else {
      await DBISAR.sharedInstance.saveToDB(SearchHistoryModelISAR(
        searchTxt: widget.searchQuery,
        pubKey: userDB?.pubKey ?? null,
        name: userDB?.name ?? null,
        picture: userDB?.picture ?? null,
      ));
      LogUtil.e('Michael: _updateSearchHistory count =');
    }
  }

  void _gotoSearchChatDetailPage(ChatMessage chatMessage) {
    OXNavigator.pushPage(
      context,
      (context) => SearchChatDetailPage(
        searchQuery: widget.searchQuery,
        chatMessage: chatMessage,
      ),
    );
  }

  void _gotoChatMessagePage(ChatMessage item) {
    final type = item.chatType;
    final sessionModel = OXChatBinding.sharedInstance.sessionMap[item.chatId];
    if (sessionModel == null) return;
    switch (type) {
      case ChatType.chatSingle:
      case ChatType.chatChannel:
      case ChatType.chatSecret:
      case ChatType.chatGroup:
      case ChatType.chatRelayGroup:
        ChatMessagePage.open(
          context: context,
          communityItem: sessionModel,
          anchorMsgId: item.msgId,
        );
        break;
    }
  }

  void _gotoContactSession(UserDBISAR userDB) {
    _updateSearchHistory(userDB);
    ChatMessagePage.open(
      context: context,
      communityItem: ChatSessionModelISAR(
        chatId: userDB.pubKey,
        chatName: userDB.name,
        sender: OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
        receiver: userDB.pubKey,
        chatType: ChatType.chatSingle,
      ),
    );
  }

  void _gotoGroupSession(GroupUIModel groupUIModel) {
    if (groupUIModel.chatType == ChatType.chatGroup || groupUIModel.chatType == ChatType.chatRelayGroup) {
      ChatMessagePage.open(
        context: context,
        communityItem: ChatSessionModelISAR(
          chatId: groupUIModel.groupId,
          chatName: groupUIModel.name,
          chatType: groupUIModel.chatType,
          avatar: groupUIModel.picture,
          groupId: groupUIModel.groupId,
        ),
      );
    }
  }
}



