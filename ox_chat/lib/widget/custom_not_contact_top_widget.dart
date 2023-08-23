import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';

///Title: custom_not_contact_top_widget
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/8/23 14:42
class CustomNotContactTopWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CustomNotContactTopWidgetState();

}

class _CustomNotContactTopWidgetState extends State<CustomNotContactTopWidget>{
  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: Adapt.px(38),
      child: Row(
        children: [

        ],
      ),
    );
  }

}