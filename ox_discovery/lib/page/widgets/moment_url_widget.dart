import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_discovery/utils/moment_widgets_utils.dart';

class MomentUrlWidget extends StatefulWidget {
  final String url;
  const MomentUrlWidget({super.key, required this.url});

  @override
  _MomentUrlWidgetState createState() => _MomentUrlWidgetState();
}

class _MomentUrlWidgetState extends State<MomentUrlWidget> {
  PreviewData? urlData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUrlInfo();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _getUrlInfo();
    }
  }

  void _getUrlInfo() async {
    urlData = await WebURLHelper.getPreviewData(widget.url);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    if (urlData == null) return const SizedBox();
    return GestureDetector(
      onTap: () {
        OXNavigator.presentPage(
            context,
            allowPageScroll: true,
            (context) => CommonWebView(widget.url),
            fullscreenDialog: true);
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10.px,
        ),
        padding: EdgeInsets.all(10.px),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.px)),
          border: Border.all(
            width: 1.px,
            color: ThemeColor.gray1,
          ),
        ),
        child: Column(
          children: [
            Text(
              urlData!.title ?? '',
              style: TextStyle(
                fontSize: 15.px,
                color: ThemeColor.white,
              ),
            ).setPaddingOnly(bottom: 20.px),
            Text(
              getDescription(urlData!.description ?? ''),
              style: TextStyle(
                fontSize: 15.px,
                color: ThemeColor.white,
              ),
            ).setPaddingOnly(bottom: 20.px),
            MomentWidgetsUtils.clipImage(
              borderRadius: 10.px,
              child: OXCachedNetworkImage(
                imageUrl: urlData?.image?.url ?? '',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDescription(String description){
    if(description.length > 200){
      return description.substring(0,200) + '...';
    }
    return description;
  }
}
