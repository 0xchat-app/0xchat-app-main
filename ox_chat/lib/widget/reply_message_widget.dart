
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';

class ReplyMessageWidget extends StatelessWidget {

  ReplyMessageWidget(this.displayContent, {this.deleteCallback = null});

  final ValueNotifier<String?> displayContent;

  final VoidCallback? deleteCallback;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: this.displayContent,
      child: SizedBox(),
      builder: (context, displayContent, child) {
        if (displayContent == null) {
          return SizedBox();
        }
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(12)),
            color: ThemeColor.color190,
          ),
          margin: EdgeInsets.only(bottom: Adapt.px(10)),
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(12), vertical: Adapt.px(4)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayContent,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ThemeColor.color120,
                    fontSize: 12,
                  ),
                ),
              ),
              if (deleteCallback != null)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: CommonImage(
                    iconName: 'icon_clearbutton.png',
                    fit: BoxFit.fill,
                    width: Adapt.px(20),
                    height: Adapt.px(20),
                  ),
                  onTap: () {
                    deleteCallback?.call();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}