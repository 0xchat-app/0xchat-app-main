import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_long_content_page.dart';


import '../../model/moment_extension_model.dart';
import '../../utils/discovery_utils.dart';

class MomentArticlePage extends StatefulWidget {
  final String naddr;

  const MomentArticlePage({super.key, required this.naddr});

  @override
  MomentArticlePageState createState() => MomentArticlePageState();
}

class MomentArticlePageState extends State<MomentArticlePage> {
  Map<String, dynamic>? articleInfo;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.naddr != oldWidget.naddr) {
      _initData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLongContentPage(
      title: 'Article',
      surfacePic: articleInfo?['content']['image'],
      timeStamp: int.parse(articleInfo?['content']?['createTime'] ?? '0') * 1000,
      userName: articleInfo?['content']['authorName'] ?? '--',
      userPic: articleInfo?['content']['authorIcon'] ?? '',
      content: articleInfo?['content']['note'] ?? '',
      isShowOriginalText: false,
    );
  }

  void _initData() async {
    final naddrAnalysisCache =
        OXMomentCacheManager.sharedInstance.naddrAnalysisCache;

    if (naddrAnalysisCache[widget.naddr] != null) {
      articleInfo = naddrAnalysisCache[widget.naddr];
      if (mounted) {
        setState(() {});
      }
      return;
    }
    final info = await DiscoveryUtils.tryDecodeNostrScheme(widget.naddr);
    if (info != null) {
      naddrAnalysisCache[widget.naddr] = info;
      articleInfo = info;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
