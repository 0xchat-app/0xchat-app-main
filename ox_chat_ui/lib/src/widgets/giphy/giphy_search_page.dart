import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

import '../../models/giphy_general_model.dart';
import '../../models/giphy_image.dart';
import 'giphy_grid_view.dart';
import 'giphy_search_bar.dart';

class GiphySearchPage extends StatefulWidget {
  final GiphyCategory category;

  final ValueSetter<GiphyImage>? onSelected;

  const GiphySearchPage({super.key, required this.category,this.onSelected});

  @override
  State<GiphySearchPage> createState() => _GiphySearchPageState();
}

class _GiphySearchPageState extends State<GiphySearchPage> {
  String _queryString = '';

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height * 0.75;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: Adapt.px(height),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color190,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Adapt.px(12)),
            child: GiphySearchBar(
              onSubmitted: (value) {
                setState(() {
                  _queryString = value;
                });
              },
            ),
          ),
          Expanded(
            child: GiphyGridView(category: widget.category, queryString: _queryString,onSelected: widget.onSelected,),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : Adapt.px(12), top: Adapt.px(12)),
            child: Text(
              'Powered by GIPHY',
              style: TextStyle(
                  fontSize: Adapt.px(14),
                  fontWeight: FontWeight.w400,
                  color: ThemeColor.color0),
            ),
          ),
        ],
      ),
    );
  }

  void show(GiphyCategory category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => GiphySearchPage(category: category),
    );
  }
}
