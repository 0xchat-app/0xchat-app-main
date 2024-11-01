
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';

class ContactLinksWidget extends StatefulWidget {
  @override
  ContactLinksWidgetState createState() => new ContactLinksWidgetState();
}

class ContactLinksWidgetState extends State<ContactLinksWidget> {
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _linkItemWidgetList();
  }

  ListView _linkItemWidgetList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: true,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) => _linkItemWidget(index),
    );
  }

  Widget _linkItemWidget(index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonImage(
            iconName: "moment_option.png",
            width: Adapt.px(24),
            height: Adapt.px(24),
            color: ThemeColor.color100,
            package: 'ox_discovery',
          ).setPaddingOnly(right: 16.px),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Link’s title',
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: 14.px,
                  fontWeight: FontWeight.w600,
                ),
              ).setPaddingOnly(bottom: 2.px),
              Container(
                width: 300.px,
                child: Text(
                  'Link’s content,Link’s content,Link’s content,Link’s content,Link’s content,Link’s content,Link’s content,Link’s content,Link’s content,Link’s content,Link’s content,Link’s content.https://Segram/2xwz2H0w',
                  style: TextStyle(
                    color: ThemeColor.color120,
                    fontSize: 12.px,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 8.px));
  }



}
