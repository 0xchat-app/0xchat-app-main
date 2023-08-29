import 'package:flutter/material.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:chatcore/chat-core.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {

  List<String> _blockList = [];

  @override
  void initState() {
    super.initState();
    getUserBlockList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Privacy',
        centerTitle: true,
        useLargeTitle: false,
      ),
      backgroundColor: ThemeColor.color190,
      body: _buildBody().setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24))),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildItem(
          leading: CommonImage(
            iconName: 'icon_privacy_block.png',
            width: Adapt.px(32),
            height: Adapt.px(32),
            package: 'ox_usercenter',
          ),
          content: 'Blocked Users',
          actions: Row(
            children: [
              Text(
                _blockList.length.toString(),
                style: TextStyle(
                    fontSize: Adapt.px(16),
                    fontWeight: FontWeight.w400,
                    color: ThemeColor.color100),
              ),
              CommonImage(
                iconName: 'icon_arrow_more.png',
                width: Adapt.px(24),
                height: Adapt.px(24),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem({String? content, Widget? leading, Widget? actions, Color? contentColor}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Adapt.px(12), horizontal: Adapt.px(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: Row(children: [
        leading ?? Container(),
        SizedBox(width: Adapt.px(12),),
        Expanded(
          child: Text(
            content ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w400,
              color: contentColor ?? ThemeColor.color0,
              height: Adapt.px(22) / Adapt.px(16),
            ),
          ),
        ),
        actions ?? Container()
      ]),
    );
  }

  void getUserBlockList(){
    List<String>?  blockResult = Contacts.sharedInstance.blockList;
    if(blockResult != null){
      setState(() {
        _blockList = blockResult;
      });
    }
  }
}
