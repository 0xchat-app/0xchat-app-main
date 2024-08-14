import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_theme/ox_theme.dart';

class CustomAvatarStack extends StatefulWidget {
  final List<String> imageUrls;
  final double avatarSize;
  final double spacing;
  final double borderWidth;
  final Color borderColor;
  final int maxAvatars;

  CustomAvatarStack({
    required this.imageUrls,
    this.avatarSize = 50.0,
    this.spacing = 10.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.white,
    this.maxAvatars = 4,
  });

  @override
  State<CustomAvatarStack> createState() => _CustomAvatarStackState();

}

class _CustomAvatarStackState extends State<CustomAvatarStack> {

  ThemeStyle _themeStyle = ThemeManager.getCurrentThemeStyle();

  @override
  void initState() {
    super.initState();
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
  }

  @override
  Widget build(BuildContext context) {
    final int actualAvatars = min(widget.imageUrls.length, widget.maxAvatars);
    final avatarSize = widget.avatarSize;
    final spacing = widget.spacing;
    List<Widget> avatars = [];

    for (int i = 0; i < actualAvatars; i++) {
      final imageUrl = widget.imageUrls[i];
      avatars.insert(
        0,
        Positioned(
          left: i * (avatarSize - spacing),
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _themeStyle == ThemeStyle.dark ? Colors.black : Colors.white,
              border: Border.all(
                color: widget.borderColor,
                width: widget.borderWidth,
              ),
            ),
            child: RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(avatarSize / 2),
                child: imageUrl.isEmpty
                    ? _placeholderImage(width: avatarSize, height: avatarSize)
                    : OXCachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: avatarSize,
                  height: avatarSize,
                  errorWidget: (context, url, error) => _placeholderImage(),
                  placeholder: (context, url) => _placeholderImage(),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: (actualAvatars - 1) * (avatarSize - spacing) + avatarSize,
      height: avatarSize,
      child: Stack(
        children: avatars,
      ),
    );
  }

  Widget _placeholderImage({double? width, double? height}) {
    String localAvatarPath = 'assets/images/user_image.png';
    return Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: width,
      height: height,
      package: 'ox_common',
    );
  }

  onThemeStyleChange() {
    if (mounted) setState(() {
      _themeStyle = ThemeManager.getCurrentThemeStyle();
    });
  }

  @override
  void dispose() {
    ThemeManager.removeOnThemeChangedCallback(onThemeStyleChange);
    super.dispose();
  }
}