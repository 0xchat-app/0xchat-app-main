import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class CommonGradientTabBar extends StatefulWidget implements PreferredSizeWidget {
  const CommonGradientTabBar({
    super.key,
    required this.data,
    this.controller,
    this.height,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorWidth,
    this.indicatorInset,
  });

  final List<String> data;
  final TabController? controller;
  final double? height;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final double? indicatorWidth;
  final EdgeInsets? indicatorInset;

  @override
  State<CommonGradientTabBar> createState() => _CommonGradientTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(36.px);
}

class _CommonGradientTabBarState extends State<CommonGradientTabBar> with SingleTickerProviderStateMixin {

  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TabController(length: widget.data.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      controller: _controller,
      enableFeedback: true,
      automaticIndicatorColorAdjustment: true,
      indicator: GradientUnderlineTabIndicator(
        gradient: LinearGradient(
          colors: [ThemeColor.gradientMainEnd, ThemeColor.gradientMainStart],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        strokeWidth: 2.px,
      ),
      indicatorPadding: EdgeInsets.zero,
      labelPadding: EdgeInsets.only(right: 16.px),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: widget.data.map((title) {
        return Container(
          height: widget.height ?? 36.px,
          child: Center(
            child: _buildLabel(title),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLabel(String label) {
    final unSelectedLabel = Text(
      label,
      style: TextStyle(color: ThemeColor.color100),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        int index = widget.data.indexOf(label);
        bool currentIndex = _controller.index == index;
        return DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.px,
            fontWeight: FontWeight.w600,
          ),
          child: currentIndex
              ? ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        ThemeColor.gradientMainEnd,
                        ThemeColor.gradientMainStart,
                      ],
                    ).createShader(Offset.zero & bounds.size);
                  },
                  child: Text(label),
                )
              : unSelectedLabel,
        );
      },
    );
  }
}

class GradientUnderlineTabIndicator extends Decoration {
  final LinearGradient gradient;
  final double strokeWidth;

  const GradientUnderlineTabIndicator({
    required this.gradient,
    this.strokeWidth = 3.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GradientUnderlinePainter(
        gradient: gradient, strokeWidth: strokeWidth);
  }
}

class _GradientUnderlinePainter extends BoxPainter {
  final LinearGradient gradient;
  final double strokeWidth;

  _GradientUnderlinePainter({required this.gradient, this.strokeWidth = 3.0});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect =
        Offset(offset.dx, configuration.size!.height - strokeWidth) &
            Size(configuration.size!.width, strokeWidth);
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, paint);
  }
}
