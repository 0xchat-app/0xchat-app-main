
import 'package:flutter/cupertino.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonSVG extends StatelessWidget {

  final String iconName;

  final bool useTheme;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit fit;

  final String package;

  CommonSVG({
    required this.iconName,
    this.useTheme = false,
    this.color,
    this.height,
    this.width,
    this.package = 'ox_common',
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SvgPicture.asset(
      useTheme
          ? ThemeManager.images('assets/common_svg/$iconName')
          : 'assets/common_svg/$iconName',
      color: this.color,
      semanticsLabel: '',
      package: this.package,
      fit: this.fit,
      width: this.width,
      height: this.height,
      colorBlendMode: BlendMode.src
    );
  }
}