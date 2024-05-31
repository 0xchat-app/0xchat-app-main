import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_theme/ox_theme.dart';

class ProcessController {
  ValueNotifier<int?> process = ValueNotifier(null);
}

class SendProgressWidget extends StatefulWidget {
  final ProcessController controller;
  final int totalCount;

  const SendProgressWidget({Key? key, required this.controller, required this.totalCount}) : super(key: key);

  @override
  State<SendProgressWidget> createState() => _SendProgressWidgetState();
}

class _SendProgressWidgetState extends State<SendProgressWidget> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.controller.process,
        builder: (context, value, child) {
          if (value == null || value > widget.totalCount) return Container();
          return Center(
            child: Container(
              padding: EdgeInsets.all(20.px),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.px),
                color: ThemeManager.getCurrentThemeStyle() == ThemeStyle.dark ? Colors.black : const Color(0xFFEAECEF),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20.px,
                    height: 20.px,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.px,
                      color: ThemeColor.red,
                    ),
                  ),
                  SizedBox(height: 10.px,),
                  Text(
                    'Sending: $value / ${widget.totalCount}',
                    style: TextStyle(color: ThemeColor.gray02, fontSize: 14.px),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

}