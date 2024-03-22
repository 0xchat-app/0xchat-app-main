import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';

import '../../models/giphy_general_model.dart';
import '../../models/giphy_image.dart';
import '../input/input_face_page.dart';
import 'giphy_grid_view.dart';
import 'giphy_search_bar.dart';
import 'giphy_search_page.dart';
import 'giphy_tab_bar.dart';

extension GiphyCategoryTab on GiphyCategory {
  String get label {
    switch (this) {
      case GiphyCategory.GIFS:
        return Localized.text('ox_chat_ui.giphy_gif');
      case GiphyCategory.STICKERS:
        return Localized.text('ox_chat_ui.giphy_sticker');
      case GiphyCategory.EMOJIS:
        return Localized.text('ox_chat_ui.giphy_emoji');
      case GiphyCategory.COLLECT:
        return Localized.text('ox_chat_ui.giphy_collect');
    }
  }
}

class GiphyPicker extends StatefulWidget {

  final ValueSetter<GiphyImage>? onSelected;

  final TextEditingController? textController;

  const GiphyPicker({super.key,this.onSelected,this.textController});

  @override
  State<GiphyPicker> createState() => _GiphyPickerState();
}

class _GiphyPickerState extends State<GiphyPicker> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final ScrollController _scrollController = ScrollController();

  int _selectedIndex = 0;

  bool _isAgreeUseGiphy = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: GiphyCategory.values.length, vsync: this);
    _getGiphyUseState();
    _tabController.addListener(() {
      _selectedIndex = _tabController.index;
      setState(() {});
    });
  }

  void _getGiphyUseState() async {
    _isAgreeUseGiphy = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_IS_AGREE_USE_GIPHY, defaultValue: false);
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: Adapt.px(12)),
    decoration: BoxDecoration(
      color: ThemeColor.color190,
      borderRadius: BorderRadius.vertical(top: Radius.circular(Adapt.px(12))),
    ),
    child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
            bottom: GiphyTabBar(controller: _tabController,),
            // bottom: PreferredSize(preferredSize: Size.fromHeight(Adapt.px(38)),child: _buildTabBar(),),
          ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: Adapt.px(12),
              ),
            ),
          _isAgreeUseGiphy && GiphyCategory.values[_selectedIndex] != GiphyCategory.EMOJIS && GiphyCategory.values[_selectedIndex] != GiphyCategory.COLLECT ? SliverPadding(
              padding: EdgeInsets.only(bottom: Adapt.px(12)),
              sliver: SliverToBoxAdapter(
                child: GiphySearchBar(
                  hintText: '${Localized.text('ox_chat_ui.giphy_search')} Giphy',
                  enable: false,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (BuildContext context)=> GiphySearchPage(
                          category: GiphyCategory.values[_selectedIndex],
                          onSelected: widget.onSelected,
                        )
                    );
                  },
                ),
              ),
            ) : SliverToBoxAdapter(),
           SliverFillRemaining(
             child: TabBarView(
               controller: _tabController,
               children: GiphyCategory.values.map((item) {
                  if (item.name == 'EMOJIS') {
                    return InputFacePage(textController: widget.textController,);
                  }
                  if (!_isAgreeUseGiphy && (GiphyCategory.values[_selectedIndex] == GiphyCategory.GIFS || GiphyCategory.values[_selectedIndex] == GiphyCategory.STICKERS)){
                    return _giphyHintView();
                  }
                  return GiphyGridView(
                    category: item,
                    onSelected: widget.onSelected,
                  );
                }).toList(),
              ),
           )
          ],
      ),
  );


  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  Widget _giphyHintView()=> Container(
    padding: EdgeInsets.symmetric(horizontal: 24.px),
    decoration: BoxDecoration(
      color: ThemeColor.color190,
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.px)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonImage(iconName: 'icon_chat_giphy_hint.png', package: 'ox_chat_ui', width: 163.9.px, height: 35.px),
        SizedBox(height: 32.px),
        Text(
          Localized.text('ox_chat_ui.giphy_use_hint'),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.px,
            color: ThemeColor.titleColor,
            height: 1.5,
          ),
        ),
        SizedBox(height: 32.px),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_IS_AGREE_USE_GIPHY, true);
            setState(() {
              _isAgreeUseGiphy = true;
            });
          },
          child: Container(
            width: 160.px,
            height: 46.px,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.px),
              color: ThemeColor.color180,
              gradient: LinearGradient(
                colors: [
                  ThemeColor.gradientMainEnd,
                  ThemeColor.gradientMainStart,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              Localized.text('ox_chat_ui.giphy_continue'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.px,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
