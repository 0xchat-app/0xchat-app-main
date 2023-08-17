

import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class InputMoreItem {
  const InputMoreItem({required this.id, required this.title, required this.iconName, required this.action,});
  final String id;
  final String Function() title;
  final String iconName;
  final Function(BuildContext context) action;
}

class InputMorePage extends StatefulWidget {
  const InputMorePage({Key? key, required this.items}) : super(key: key);

  final List<InputMoreItem> items;

  @override
  State<InputMorePage> createState() => _InputMorePageState();
}

class _InputMorePageState extends State<InputMorePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) =>
      Container(
        decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.circular(12),
        ),
        child:Container(
          margin: EdgeInsets.only(top: Adapt.px(12)),
          child:  GridView.count(
            crossAxisCount: 4, // The number of columns displayed per row
            padding: EdgeInsets.all(Adapt.px(12)),
            mainAxisSpacing: Adapt.px(12), // Space between columns
            crossAxisSpacing: Adapt.px(12), // Line spacing
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              return  GestureDetector(
                child: Container(
                  color: Colors.transparent, // Background color for each grid
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: Adapt.px(48),
                        height: Adapt.px(48),
                        margin: EdgeInsets.only(bottom: Adapt.px(8)),
                        child: Image.asset(
                          'assets/images/${item.iconName}',
                          package: 'ox_chat_ui',
                        ),
                      ),
                      Text(
                        '${item.title()}',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                onTap: () => item.action(context),
              );
            }),
          ),
        ),
      );


}
