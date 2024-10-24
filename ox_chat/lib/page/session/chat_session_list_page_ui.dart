part of 'chat_session_list_page.dart';

///Title: chat_session_list_page_ui
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2024
///@author Michael
///CreateTime: 2024/10/22 18:21
extension ChatSessionListPageUI on ChatSessionListPageState{

  Widget _buildListViewItem(context, int index) {
    if(index >= _msgDatas.length) return SizedBox();
    ChatSessionModelISAR item = _msgDatas[index];
    bool isMuteCurrent = ChatSessionUtils.getChatMute(item);
    GlobalKey tempKey = GlobalKey(debugLabel: index.toString());
    return GestureDetector(
      onHorizontalDragDown: (details) {
        _dismissSlidable();
        _latestGlobalKey = tempKey;
      },
      child: Container(
        color: ThemeColor.color200,
        height: 84.px,
        child: Slidable(
          key: ValueKey("$index"),
          endActionPane: ActionPane(
            extentRatio: 0.44,
            motion: const ScrollMotion(),
            children: [
              CustomSlidableAction(
                onPressed: (BuildContext _) async {
                  ChatSessionUtils.setChatMute(item, !isMuteCurrent);
                },
                backgroundColor: ThemeManager.colors('ox_chat.actionRoyalBlue'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    assetIcon(isMuteCurrent ? 'icon_unmute.png' : 'icon_mute.png', 32, 32, color: ThemeColor.color0),
                    Text(
                      (isMuteCurrent ? 'un_mute_item' : 'mute_item').localized(),
                      style: TextStyle(color: Colors.white, fontSize: Adapt.px(12)),
                    ),
                  ],
                ),
              ),
              CustomSlidableAction(
                onPressed: (BuildContext _) async {
                  OXCommonHintDialog.show(context,
                      content: item.chatType == ChatType.chatSecret
                          ? Localized.text('ox_chat.secret_message_delete_tips')
                          : Localized.text('ox_chat.message_delete_tips'),
                      actionList: [
                        OXCommonHintAction.cancel(onTap: () {
                          OXNavigator.pop(context);
                        }),
                        OXCommonHintAction.sure(
                            text: Localized.text('ox_common.confirm'),
                            onTap: () async {
                              OXNavigator.pop(context);
                              int count = 0;
                              if(item.chatType == ChatType.chatNotice) {
                                count = await _deleteStrangerSessionList();
                              } else {
                                count = await OXChatBinding.sharedInstance.deleteSession([item.chatId]);
                              }
                              if (count > 0) {
                                _merge();
                              }
                            }),
                      ],
                      isRowAction: true);
                },
                backgroundColor: ThemeManager.colors('ox_chat.actionPurple'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    assetIcon('icon_chat_delete.png', 32, 32, color: ThemeColor.color0),
                    Text(
                      'delete'.localized(),
                      style: TextStyle(color: Colors.white, fontSize: Adapt.px(12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          child: Stack(
            key: tempKey,
            children: [
              _buildBusinessInfo(item, index),
              item.alwaysTop
                  ? Container(
                alignment: Alignment.topRight,
                child: assetIcon('icon_red_always_top.png', 12, 12),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessInfo(ChatSessionModelISAR item, int index) {
    return ValueListenableBuilder<double>(
      valueListenable: _scaleList[index],
      builder: (context, scale, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _itemFn(item);
          },
          onLongPress: () async {
            if (item.chatId == CommonConstant.NOTICE_CHAT_ID) return;
            _scaleList[index].value = 0.96;
            await Future.delayed(Duration(milliseconds: 80));
            _scaleList[index].value = 1.0;
            await Future.delayed(Duration(milliseconds: 80));
            ChatMessagePage.open(
              context: context,
              communityItem: item,
              unreadMessageCount: item.unreadCount,
              isLongPressShow: true,
            );
          },
          child: AnimatedScale(
            scale: scale,
            duration: Duration(milliseconds: 80),
            curve: Curves.easeOut,
            child: Container(
              padding: EdgeInsets.only(top: Adapt.px(12), left: Adapt.px(16), bottom: Adapt.px(12), right: Adapt.px(16)),
              constraints: BoxConstraints(
                minWidth: 30.px,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        _getMsgIcon(item),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    _buildItemName(item),
                                    if (_getChatSessionMute(item))
                                      CommonImage(
                                        iconName: 'icon_mute.png',
                                        width: Adapt.px(16),
                                        height: Adapt.px(16),
                                        package: 'ox_chat',
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: Adapt.px(5)),
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: _subTitleMaxW),
                                    child: _buildItemSubtitle(item),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      _buildReadWidget(item),
                      SizedBox(
                        height: Adapt.px(18),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Text(OXDateUtils.convertTimeFormatString2(item.createTime* 1000, pattern: 'MM-dd'),
                            textAlign: TextAlign.left, maxLines: 1, style: _Style.newsContentSub()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getMsgIcon(ChatSessionModelISAR item) {
    if (item.chatType == '1000') {
      return assetIcon('icon_notice_avatar.png', 60, 60);
    } else {
      String showPicUrl = ChatSessionUtils.getChatIcon(item);
      String localAvatarPath = ChatSessionUtils.getChatDefaultIcon(item);
      Widget? sessionTypeWidget = ChatSessionUtils.getTypeSessionView(item.chatType, item.chatId);
      return Container(
        width: Adapt.px(60),
        height: Adapt.px(60),
        child: Stack(
          children: [
            (item.chatType == ChatType.chatGroup)
                ? Center(
                child: GroupedAvatar(
                  avatars: _groupMembersCache[item.groupId] ?? [],
                  size: 60.px,
                ))
                : ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(60)),
              child: BaseAvatarWidget(
                imageUrl: '${showPicUrl}',
                defaultImageName: localAvatarPath,
                size: Adapt.px(60),
              ),
            ),
            (item.chatType == ChatType.chatSingle)
                ? Positioned(
              bottom: 0,
              right: 0,
              child: FutureBuilder<BadgeDBISAR?>(
                initialData: _badgeCache[item.chatId],
                builder: (context, snapshot) {
                  return (snapshot.data != null)
                      ? OXCachedNetworkImage(
                    imageUrl: snapshot.data!.thumb,
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    fit: BoxFit.cover,
                  )
                      : Container();
                },
                future: _getUserSelectedBadgeInfo(item),
              ),
            )
                : SizedBox(),
            Positioned(
              bottom: 0,
              right: 0,
              child: sessionTypeWidget,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildItemName(ChatSessionModelISAR item) {
    late Widget nameView;
    String showName = ChatSessionUtils.getChatName(item);
    if (item.chatType == ChatType.chatSingle || item.chatType == ChatType.chatSecret){
      nameView = ValueListenableBuilder<UserDBISAR>(
        valueListenable: Account.sharedInstance.getUserNotifier(item.getOtherPubkey),
        builder: (context, value, child) {
          return MyText(showName, 16.px, ThemeColor.color10, textAlign: TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600);
        },
      );
    } else {
      nameView =MyText(showName, 16.px, ThemeColor.color10, textAlign: TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600);
    }
    return Container(
      margin: EdgeInsets.only(right: Adapt.px(4)),
      child: item.chatType == ChatType.chatSecret
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonImage(
            iconName: 'icon_lock_secret.png',
            width: Adapt.px(16),
            height: Adapt.px(16),
            package: 'ox_chat',
          ),
          SizedBox(
            width: Adapt.px(4),
          ),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                  ThemeColor.gradientMainEnd,
                  ThemeColor.gradientMainStart,
                ],
              ).createShader(Offset.zero & bounds.size);
            },
            child: nameView,
          ),
        ],
      )
          : nameView,
      constraints: BoxConstraints(maxWidth: _nameMaxW),
    );
  }

  Widget _buildItemSubtitle(ChatSessionModelISAR announceItem) {
    final isMentioned = announceItem.isMentioned;
    if (isMentioned) {
      return RichText(
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: '[${Localized.text('ox_chat.session_content_mentioned')}]',
              style: _Style.hintContentSub(),
            ),
            TextSpan(
              text: announceItem.content ?? '',
              style: _Style.newsContentSub(),
            ),
          ],
        ),
      );
    }

    final draft = announceItem.draft ?? '';
    if (draft.isNotEmpty) {
      return Text(
        '[${Localized.text('ox_chat.session_content_draft')}]$draft',
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _Style.hintContentSub(),
      );
    }
    return Text(
      announceItem.content ?? '',
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _Style.newsContentSub(),
    );
  }

  String getLastMessageStr(MessageDBISAR? messageDB) {
    if (messageDB == null) {
      return '';
    }
    final decryptedContent = json.decode(messageDB.decryptContent);
    MessageContentModel contentModel = MessageContentModel.fromJson(decryptedContent);
    if (contentModel.contentType == null) {
      return '';
    }
    if (messageDB.type == MessageType.text) {
      return contentModel.content ?? '';
    } else {
      return '[${contentModel.contentType.toString().split('.').last}]';
    }
  }

  bool _getChatSessionMute(ChatSessionModelISAR item) {
    bool isMute = ChatSessionUtils.getChatMute(item);
    if (isMute != _muteCache[item.chatId]) {
      _muteCache[item.chatId] = isMute;
    }
    return isMute;
  }

  Widget _buildReadWidget(ChatSessionModelISAR item) {
    int read = item.unreadCount;
    bool isMute = _getChatSessionMute(item);
    if (isMute) {
      if (read > 0) {
        return ClipOval(
          child: Container(
            alignment: Alignment.center,
            color: ThemeColor.color110,
            width: Adapt.px(12),
            height: Adapt.px(12),
          ),
        );
      } else {
        return SizedBox();
      }
    }
    if (read > 0 && read < 10) {
      return ClipOval(
        child: Container(
          alignment: Alignment.center,
          color: ThemeColor.red1,
          width: Adapt.px(17),
          height: Adapt.px(17),
          child: Text(
            read.toString(),
            style: _Style.read(),
          ),
        ),
      );
    } else if (read >= 10 && read < 100) {
      return Container(
        alignment: Alignment.center,
        width: Adapt.px(22),
        height: Adapt.px(20),
        decoration: BoxDecoration(
          color: ThemeColor.red1,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(13.5))),
        ),
        padding: EdgeInsets.symmetric(vertical: Adapt.px(3), horizontal: Adapt.px(3)),
        child: Text(
          read.toString(),
          style: _Style.read(),
        ),
      );
    } else if (read >= 100) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ThemeColor.red1,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(13.5))),
        ),
        padding: EdgeInsets.symmetric(vertical: Adapt.px(3), horizontal: Adapt.px(3)),
        child: Text(
          '99+',
          style: _Style.read(),
        ),
      );
    }
    return Container();
  }

  Widget _topSearch() {
    return InkWell(
      onTap: () {
        SearchPage().show(context);
      },
      highlightColor: Colors.transparent,
      radius: 0.0,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: Adapt.px(24),
          vertical: Adapt.px(6),
        ),
        height: Adapt.px(48),
        decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(16))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: Adapt.px(18)),
              child: assetIcon(
                'icon_chat_search.png',
                24,
                24,
              ),
            ),
            SizedBox(
              width: Adapt.px(8),
            ),
            MyText(
              'search'.localized(),
              15,
              ThemeColor.color150,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}

class _Style {

  static TextStyle newsContentSub() {
    return new TextStyle(
      fontSize: Adapt.px(14),
      fontWeight: FontWeight.w400,
      color: ThemeColor.color120,
    );
  }

  static TextStyle hintContentSub() {
    return new TextStyle(
      fontSize: Adapt.px(14),
      fontWeight: FontWeight.w400,
      color: ThemeColor.red,
    );
  }

  static TextStyle read() {
    return new TextStyle(
      fontSize: Adapt.px(12),
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
  }
}