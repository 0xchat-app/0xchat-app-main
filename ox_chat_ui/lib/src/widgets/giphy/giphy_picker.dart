import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

import '../../models/giphy_general_model.dart';
import '../../models/giphy_image.dart';
import 'giphy_grid_view.dart';
import 'giphy_search_bar.dart';
import 'giphy_search_page.dart';
import 'giphy_tab_bar.dart';

extension GiphyCategoryTab on GiphyCategory {
  String get label {
    switch (this) {
      case GiphyCategory.GIFS:
        return 'GIFs';
      case GiphyCategory.STICKERS:
        return 'Stickers';
      case GiphyCategory.EMOJIS:
        return 'Emojis';
    }
  }
}

class GiphyPicker extends StatefulWidget {

  final ValueSetter<GiphyImage>? onSelected;

  const GiphyPicker({super.key,this.onSelected});

  @override
  State<GiphyPicker> createState() => _GiphyPickerState();
}

class _GiphyPickerState extends State<GiphyPicker> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final ScrollController _scrollController = ScrollController();

  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: Adapt.px(12)),
    decoration: BoxDecoration(
      color: ThemeColor.color190,
      borderRadius: BorderRadius.circular(12),
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
          GiphyCategory.values[_selectedIndex] != GiphyCategory.EMOJIS ? SliverPadding(
              padding: EdgeInsets.only(bottom: Adapt.px(12)),
              sliver: SliverToBoxAdapter(
                child: GiphySearchBar(
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
               children: GiphyCategory.values
                   .map((item) => GiphyGridView(
                 category: item,
                 onSelected: widget.onSelected,
               )).toList(),
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
}
