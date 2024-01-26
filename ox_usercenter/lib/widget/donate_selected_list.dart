import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_usercenter/widget/custom_gradient_border_widget.dart';

class DonateSelectedList extends StatefulWidget {

  final List<Widget> item;
  final String? title;
  final ValueSetter<int>? onSelected;
  final Widget? customStasInputBox;
  final int currentIndex;

  const DonateSelectedList({required this.item, this.title, this.onSelected, this.customStasInputBox, this.currentIndex = -1, Key? key}) : super(key: key);

  @override
  State<DonateSelectedList> createState() => _DonateSelectedListState();
}

class _DonateSelectedListState extends State<DonateSelectedList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: ThemeColor.color190,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Adapt.px(12),
          ),
        ),
      ),
      padding: EdgeInsets.all(Adapt.px(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.title != null
              ? Container(
                  padding: EdgeInsets.only(
                    bottom: Adapt.px(24),
                  ),
                  child: Text(
                    widget.title!,
                    style: TextStyle(
                        fontSize: Adapt.px(16), fontWeight: FontWeight.w600),
                  ),
                )
              : Container(),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: CustomGradientBorderWidget(
                    borderRadius: Adapt.px(12),
                    border: Adapt.px(2),
                    gradient: LinearGradient(
                      colors: widget.currentIndex == index ? [
                        ThemeColor.gradientMainStart,
                        ThemeColor.gradientMainEnd,
                      ] : [
                        Colors.transparent,
                        Colors.transparent,
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                    child: widget.item[index]),
                onTap: (){
                  if(widget.onSelected!=null){
                    widget.onSelected!(index);
                  }
                },
              );
            },
            itemCount: widget.item.length,
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: Adapt.px(10),
              );
            },
            padding: EdgeInsets.only(bottom: Adapt.px(24)),
          ),
          widget.customStasInputBox != null ? widget.customStasInputBox! : Container(),
        ],
      ),
    );
  }
}
