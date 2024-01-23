import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class CommonCard extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Widget? child;
  const CommonCard({super.key, this.height, this.width, this.radius, this.verticalPadding, this.horizontalPadding, this.child});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 13.px,
        fontWeight: FontWeight.w400,
        color: ThemeColor.color100,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 16.px,horizontal: horizontalPadding ?? 16.px),
        // height: height ?? 48.px,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.circular(radius ?? 16.px),
        ),
        child: child,
      ),
    );
  }
}

class CommonCardItem extends StatelessWidget {
  final String? label;
  final String? content;
  final Widget? action;

  const CommonCardItem({super.key, this.label, this.content, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px,vertical: 12.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(label ?? '',style: TextStyle(fontSize: 14.px,height: 22.px / 14.px),),
              const Spacer(),
              action ?? Container(),
            ],
          ),
          SizedBox(height: 4.px,),
          Text(content ?? '',style: TextStyle(fontSize: 14.px,color: ThemeColor.color0,height: 20.px / 14.px),)
        ],
      ),
    );
  }
}

class CardItemModel {
  final String? label;
  final String? content;

  CardItemModel({this.label, this.content});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardItemModel &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          content == other.content;

  @override
  int get hashCode => label.hashCode ^ content.hashCode;
}
