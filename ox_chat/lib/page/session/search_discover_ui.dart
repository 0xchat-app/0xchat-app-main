import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/page/session/search_page.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

///Title: search_discover_ui
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/29 10:27
extension SearchDiscoverUI on SearchPageState{


  Widget discoverPage(){
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      body: Column(
        children: [
          _searchView(),
          Expanded(
            child: _discoverView().setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24))),
          ),
        ],
      ),
    );
  }

  Widget _discoverView(){
    if (searchQuery.isEmpty) {
      return Container(
        width: double.infinity,
        height: Adapt.px(22),
        alignment: Alignment.topCenter,
        child: Text(
          Localized.text('ox_chat.search_channel_tips'),
          style: TextStyle(
            fontSize: Adapt.px(15),
            color: ThemeColor.color110,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    return GroupedListView<Group, dynamic>(
      elements: dataGroups,
      groupBy: (element) => element.title,
      groupHeaderBuilder: (element){
        return Container();
      } ,
      padding: EdgeInsets.zero,
      itemBuilder: (context, element) {
        final items = element.items;
        if (element.type == SearchItemType.channel && items is List<ChannelDB>) {
          return Column(
            children: items.map((item) {
              return ListTile(
                onTap: () async {
                  if(OXUserInfoManager.sharedInstance.isLogin){
                    gotoChatGroupSession(item);
                  }else{
                    await OXModuleService.pushPage(context, "ox_login", "LoginPage", {});
                  }
                },
                leading: CircleAvatar(
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) => placeholderImage(false, 48),
                    placeholder: (context, url) => placeholderImage(false, 48),
                    fit: BoxFit.fill,
                    imageUrl: item.picture ?? '',
                    width: Adapt.px(48),
                    height: Adapt.px(48),
                  ),
                ),
                title: Text(
                  item.name ?? '',
                ).setPadding(EdgeInsets.only(bottom: Adapt.px(2))),
                subtitle: highlightText(item.about ?? ''),
              );
            }).toList(),
          );
        }
        return SizedBox.shrink();
      },
      itemComparator: (item1, item2) => item1.title.compareTo(item2.title),
      useStickyGroupSeparators: false,
      floatingHeader: false,
    );
  }

  void onDiscoverTextChanged(value) {
    searchQuery = value;
    loadOnlineChannelsData();
  }


  Widget _searchView() {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      height: Adapt.px(80),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: Adapt.px(24)),
              decoration: BoxDecoration(
                color: ThemeColor.color190,
                borderRadius: BorderRadius.circular(Adapt.px(16)),
              ),
              child: TextField(
                controller: editingController,
                onChanged: onDiscoverTextChanged,
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: Adapt.px(16)),
                    child: CommonImage(
                      iconName: 'icon_search.png',
                      width: Adapt.px(24),
                      height: Adapt.px(24),
                      fit: BoxFit.fill,
                    ),
                  ),
                  hintText: Localized.text('ox_chat.search'),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: Adapt.px(90),
              alignment: Alignment.center,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      ThemeColor.gradientMainEnd,
                      ThemeColor.gradientMainStart,
                    ],
                  ).createShader(Offset.zero & bounds.size);
                },
                child: Text(
                  Localized.text('ox_common.cancel'),
                  style: TextStyle(
                    fontSize: Adapt.px(15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () {
              OXNavigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}