import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../../giphy_usage_recorder.dart';
import '../../models/giphy_general_model.dart';
import '../../models/giphy_image.dart';

class GiphyGridView extends StatefulWidget {

  final GiphyCategory category;
  final ValueSetter<GiphyImage>? onSelected;
  final String? queryString;

  const GiphyGridView({
    super.key,
    this.category = GiphyCategory.GIFS,
    this.onSelected,
    this.queryString,
  });

  @override
  State<GiphyGridView> createState() => _GiphyGridViewState();
}

class _GiphyGridViewState extends State<GiphyGridView> with AutomaticKeepAliveClientMixin{

  final ScrollController _scrollController = ScrollController();

  List<GiphyImage> _giphyImage = [];

  int _offset = 0;

  int _totalCount = 0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData(widget.category);
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading){
        //load more
        _fetchData(widget.category,offset: _offset,queryString:widget.queryString,isRefresh: true);
      }
    });
  }

  void _fetchData(GiphyCategory type,{String? queryString,int? offset,bool isRefresh = false}) async {

    // if(_giphyImage.length >= _totalCount){
    //   return;
    // }
    if(type == GiphyCategory.COLLECT){
      _giphyImage = await GiphyUsageRecorder.getUsedGiphyList();
      return;
    }

    if(isRefresh){
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final giphyGeneralModel = await GiphyService().getTrendingEndpoint(type,queryString: queryString,offset: offset);
      if(giphyGeneralModel != null) {
        setState(() {
          if(isRefresh){
            _giphyImage.addAll(giphyGeneralModel.data);
            _isLoading = false;
          }else{
            _giphyImage = giphyGeneralModel.data;
          }
          _totalCount = giphyGeneralModel.count!;
          _offset += GiphyConfig.limit;
          _isLoading = false;
        });
      }
    }catch(error) {
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if(_giphyImage.isEmpty){
      if(widget.category == GiphyCategory.COLLECT){
        return Center(
          child: CommonImage(
            iconName: 'icon_no_data.png',
            width: Adapt.px(90),
            height: Adapt.px(90),
          ),
        );
      }else{
        return Center(
          child: const CircularProgressIndicator(),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: Adapt.px(12),
              mainAxisSpacing: Adapt.px(12),
            ),
            itemBuilder: (BuildContext context, int index)=> GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Image.network(_giphyImage[index].url ?? '',
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  if (widget.onSelected != null) {
                    widget.onSelected!(_giphyImage[index]);
                    GiphyUsageRecorder.recordGiphyUsage(_giphyImage[index]);
                  }
                },
              ),
            itemCount: _giphyImage.length,
          ),
        ),
        // _isLoading ? _buildIndicator() : Container(),
      ],
    );
  }

  Widget _buildIndicator()=> Container(
    alignment: Alignment.center,
    width: Adapt.px(24),
    height: Adapt.px(24),
    child: CircularProgressIndicator(),
  );

  @override
  void didUpdateWidget(covariant GiphyGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.queryString != widget.queryString && widget.queryString != null && widget.queryString!.isNotEmpty) {
      _fetchData(widget.category, queryString: widget.queryString);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
