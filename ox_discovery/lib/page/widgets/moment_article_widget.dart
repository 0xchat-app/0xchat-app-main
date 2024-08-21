import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';

import 'package:ox_discovery/page/widgets/moment_widget.dart';
import 'package:ox_module_service/ox_module_service.dart';

import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../moments/moment_article_page.dart';
import '../moments/moments_page.dart';
import 'moment_rich_text_widget.dart';

class MomentArticleWidget extends StatefulWidget {
  final String naddr;

  const MomentArticleWidget({super.key, required this.naddr});

  @override
  MomentArticleWidgetState createState() => MomentArticleWidgetState();
}

class MomentArticleWidgetState extends State<MomentArticleWidget> {
  Map<String,dynamic>? articleInfo;

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
    return quoteMoment();
  }

  void _initData() async {
    final naddrAnalysisCache = OXMomentCacheManager.sharedInstance.naddrAnalysisCache;
    if(naddrAnalysisCache[widget.naddr] != null){
      articleInfo = naddrAnalysisCache[widget.naddr];
      if (mounted) {
        setState(() {});
      }
      return;
    }
    final info = await DiscoveryUtils.tryDecodeNostrScheme(widget.naddr);

    if(info != null){
      naddrAnalysisCache[widget.naddr] = info;
      articleInfo = info;
      if (mounted) {
        setState(() {});
      }
    }
  }



  Widget _getImageWidget() {
    Map<String,dynamic>? info = articleInfo;
    if (info == null) return const SizedBox();
    if (info['content']['image'] == null ) return const SizedBox();
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(11.5.px),
        topRight: Radius.circular(11.5.px),
      ),
      child: Container(
        width: double.infinity,
        color: ThemeColor.color100,
        child: OXCachedNetworkImage(
          imageUrl: info['content']['image'],
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              MomentWidgetsUtils.badgePlaceholderContainer(
                  height: 172, width: double.infinity),
          errorWidget: (context, url, error) =>
              MomentWidgetsUtils.badgePlaceholderContainer(
                  size: 172, width: double.infinity),
          height: 172.px,
        ),
      ),
    );
  }

  Widget quoteMoment() {
    Map<String,dynamic>? info = articleInfo;
    if (info == null) return MomentWidgetsUtils.emptyNoteMomentWidget(null,100);
    return GestureDetector(
      onTap: () {
        OXNavigator.presentPage(context, (context) => MomentArticlePage(naddr: widget.naddr));

      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.px),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.px,
            color: ThemeColor.color160,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              11.5.px,
            ),
          ),
        ),
        child: Column(
          children: [
            _getImageWidget(),
            Container(
              padding: EdgeInsets.all(12.px),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // await OXModuleService.pushPage(
                          //     context, 'ox_chat', 'ContactUserInfoPage', {
                          //   'pubkey': pubKey,
                          // });
                          // setState(() {});
                        },
                        child: MomentWidgetsUtils.clipImage(
                          borderRadius: 40.px,
                          imageSize: 40.px,
                          child: OXCachedNetworkImage(
                            imageUrl: info['content']['authorIcon'] ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                MomentWidgetsUtils
                                    .badgePlaceholderImage(),
                            errorWidget: (context, url, error) =>
                                MomentWidgetsUtils
                                    .badgePlaceholderImage(),
                            width: 40.px,
                            height: 40.px,
                          ),
                        ),
                      ),
                      Text(
                        info['content']['authorName'] ?? '--',
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.w500,
                          color: ThemeColor.color0,
                        ),
                      ).setPadding(
                        EdgeInsets.symmetric(
                          horizontal: 4.px,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          DiscoveryUtils.formatTimeAgo(int.parse(info['content']?['createTime'] ?? '0')),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.px,
                            fontWeight: FontWeight.w400,
                            color: ThemeColor.color120,
                          ),
                        ),
                      ),
                    ],
                  ).setPaddingOnly(bottom: 4.px),
                  MomentRichTextWidget(
                    text: info['content']['note'] ?? '',
                    textSize: 14.px,
                    // maxLines: 1,
                    isShowAllContent: false,
                    clickBlankCallback: ()  {
                    OXNavigator.presentPage(context, (context) => MomentArticlePage(naddr: widget.naddr));

                    },
                    showMoreCallback: ()  {
                    OXNavigator.presentPage(context, (context) => MomentArticlePage(naddr: widget.naddr));

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}