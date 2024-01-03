import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/utils/adapt.dart';

class SwitchWidget extends StatefulWidget {
  final bool value;
  final double? height;
  final double? width;
  final ValueChanged<bool>? onChanged;

  const SwitchWidget({super.key, required this.value, this.height, this.width, this.onChanged});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {

  late bool _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        setState(() {
          _value = !_value;
          if(widget.onChanged!=null){
            widget.onChanged!(_value);
          }
        });
      },
      child: CommonImage(
        iconName: widget.value && _value ? 'icon_switch_open.png' : 'icon_switch_close.png',
        height: widget.height ?? 20.px,
        width: widget.width ?? 36.px,
        package: 'ox_wallet',
      ),
    );
  }
}

