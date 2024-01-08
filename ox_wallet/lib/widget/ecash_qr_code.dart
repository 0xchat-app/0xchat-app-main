import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class EcashQrCode extends StatelessWidget {
  final ValueNotifier<String?> controller;
  final VoidCallback? onRefresh;

  const EcashQrCode({super.key, required this.controller, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260.px,
      width: 260.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.px),
        color: controller.value != null && controller.value!.isNotEmpty ? Colors.white : ThemeColor.color100,
      ),
      padding: const EdgeInsets.all(20),
      child: _buildQRCode(),
    );
  }

  Widget _buildQRCode() {
    if (controller.value == null) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.value = '';
          if (onRefresh != null) {
            onRefresh!();
          }
        },
        child: _buildTips(
          child: CommonImage(
            iconName: 'icon_set_refresh.png',
            package: 'ox_wallet',
            size: 48.px,
          ),
          tips: 'Create failed, Refresh',
        ),
      );
    }

    if (controller.value == '') {
      return _buildTips(
        child: _QRLoading(
          controller: controller,
        ),
        tips: 'Creating...',
      );
    }

    return PrettyQr(
      data: controller.value!,
      errorCorrectLevel: QrErrorCorrectLevel.M,
      typeNumber: null,
      roundEdges: true,
    );
  }

  Widget _buildTips({required Widget child, required String tips}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child,
        SizedBox(height: 10.px,),
        Text(
          tips,
          style: TextStyle(
              color: ThemeColor.color210.withOpacity(0.5),
              fontSize: 13.px,
              fontWeight: FontWeight.w400,
              height: 18.px / 13.px),
        ),
      ],
    );
  }
}

class _QRLoading extends StatefulWidget {
  final ValueNotifier<String?> controller;

  const _QRLoading({required this.controller});

  @override
  State<_QRLoading> createState() => _QRLoadingState();
}

class _QRLoadingState extends State<_QRLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800),vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.controller,
        builder: (context, value, child) {
          if (value == '') {
            _controller.repeat();
          }else{
            _controller.reset();
          }
          return RotationTransition(
            turns: _controller,
            child: Center(
              child: CommonImage(
                iconName: 'icon_set_loading.png',
                package: 'ox_wallet',
                size: 48.px,
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}




