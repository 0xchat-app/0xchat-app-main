import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';

///Title: passcode_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/7 17:28
class SecureKeypad extends StatefulWidget {

  final ValueChanged<String> onChanged;

  const SecureKeypad({super.key, required this.onChanged});

  @override
  State<SecureKeypad> createState() => SecureKeypadState();
}

class SecureKeypadState extends State<SecureKeypad> {
  final List<String> numericKey = const ['1','2','3','4','5','6','7','8','9','.','0','x'];
  final ValueNotifier _currentIndex = ValueNotifier(-1);
  final radius = Radius.circular(16.px);

  String value = '';

  @override
  void initState() {
    super.initState();
  }

  void resetCurrentIndex(){
    _currentIndex.value = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(radius),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.px,
            crossAxisSpacing: 1.px,
            childAspectRatio: 130 / 60
        ),
        itemCount: numericKey.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (_){
              _onKeyTap(numericKey[index]);
              widget.onChanged(value);
              _currentIndex.value = index;
            },
            onTapUp: (_){
              _currentIndex.value = -1;
            },
            child: ValueListenableBuilder(
              valueListenable: _currentIndex,
              builder: (context,__,child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.px),
                    color: _currentIndex.value == index ? Colors.black.withOpacity(0.2) : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: _buildKeyWidget(numericKey[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeyWidget(String key) {
    if (key == '.') {
      return const SizedBox();
    }
    if (key == 'x') {
      return CommonImage(
        iconName: 'icon_keyboard_backspace.png',
        width: 32.px,
        height: 32.px,
        package: 'ox_usercenter',
      );
    }
    return Text(
      key,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 24.sp,
          color: ThemeColor.color0),
    );
  }

  void _onKeyTap(String key) {
    if (key == 'x') {
      if (value.isNotEmpty) {
        value = value.substring(0, value.length - 1);
      }
      value = 'x';
    } else if (key != '.') {
      if (value.length < 6){
        value = key;
      }
    }
  }
}