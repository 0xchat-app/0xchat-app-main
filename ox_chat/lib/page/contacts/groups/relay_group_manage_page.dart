
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
///Title: relay_group_manage_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/6/25 15:10
class RelayGroupManagePage extends StatefulWidget{
  final RelayGroupDB relayGroupDB;
  RelayGroupManagePage({super.key, required this.relayGroupDB});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}

class _RelayGroupManagePageState extends State<RelayGroupManagePage>{

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'str_group_manage'.localized(),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24.px,
          vertical: 12.px,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              _topView(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _topView(){
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.circular(16.px),
      ),
    );
  }
}