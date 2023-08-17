import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:ox_common/utils/theme_color.dart';

class CommonGlassmorphicContainer extends StatelessWidget {
  const CommonGlassmorphicContainer({
    Key? key,
    this.height = 60.0,
    this.borderRadius = 0.0,
    this.blur = 2,//Dark mode uses 5, Day mode uses 1
    required this.child,
  }) : super(key: key);

  final double height;
  final double borderRadius;
  final double blur;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: createGlassmorphicContainer(),
      // height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(height),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.glassmorphicShadow,
            offset: Offset(
              3.0,
              1.0,
            ),
            blurRadius: 20.0,
            spreadRadius: 1.0,
            // blurStyle: BlurStyle.solid
          ),
        ],
      ),
    );
  }

  Widget createGlassmorphicContainer() {
    return GlassmorphicContainer(
      borderRadius: borderRadius,
      width: double.infinity,
      height: height,
      blur: blur,
      alignment: Alignment.bottomCenter,
      border: 0.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          // Day mode
          // Color(0xB2FFFFFF),
          // Color(0xB2FFFFFF),
          // Dark mode
          // Color(0xB2444444),
          // Color(0xB2444444),
          ThemeColor.glassmorphicBorder,
          ThemeColor.glassmorphicBorder,
        ],
        stops: const [
          0.1,
          1,
        ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          //Day Mode

          // Colors.white.withOpacity(0.1),
          // Colors.white.withOpacity(0.1),
          // Colors.white.withOpacity(0.1),
          // Colors.white.withOpacity(0.1),

          // Color(0x66F5F5F5),
          // Color(0x66F5F5F5),
          // Color(0x66F5F5F5),
          // Color(0x66F5F5F5),
          // Dark mode
          // Color(0x0c595959),
          // Color(0x0c595959),
          // Color(0x0c595959),
          // Color(0x0c595959),

          ThemeColor.glassmorphicBgColor,
          ThemeColor.glassmorphicBgColor,
          ThemeColor.glassmorphicBgColor,
          ThemeColor.glassmorphicBgColor,
        ],
      ),
      // margin: EdgeInsets.symmetric(
      //   vertical: verticalPadding, horizontal: horizontalPadding),
      child: child
    );
  }
}
