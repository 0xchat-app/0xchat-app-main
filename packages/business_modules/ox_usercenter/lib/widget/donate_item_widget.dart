import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/font_size_notifier.dart';
import 'package:ox_common/utils/theme_color.dart';

class DonateItemWidget extends StatelessWidget {

  final String? title;
  final String? subTitle;
  final Widget? leading;
  final Widget? flagWidget;

  const DonateItemWidget({this.title,this.subTitle,this.leading,this.flagWidget,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - Adapt.px(24 * 2),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(16), vertical: Adapt.px(8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Adapt.px(44),
              maxHeight: Adapt.px(44),
            ),
            child: leading ?? Container(),
          ),
          SizedBox(
            width: Adapt.px(12),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title ?? '',
                    style: TextStyle(
                        fontSize: Adapt.px(14),
                        fontWeight: FontWeight.w400,
                        color: ThemeColor.color0),
                  ),
                  SizedBox(width: Adapt.px(4),),
                  flagWidget ?? Container(),
                ],
              ),
              SizedBox(
                height: 12.px,
              ),
              Container(
                constraints: BoxConstraints(maxWidth: Adapt.screenW - 136.px, maxHeight: 44.px),
                child: Text(
                  subTitle ?? '',
                  style: TextStyle(
                    fontSize: Adapt.px(14),
                    fontWeight: FontWeight.w400,
                    color: ThemeColor.color100,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
