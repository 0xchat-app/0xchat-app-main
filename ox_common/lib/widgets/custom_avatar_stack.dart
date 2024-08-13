import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_network_image.dart';

class CustomAvatarStack extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final int actualAvatars = min(imageUrls.length, maxAvatars);
    List<Widget> avatars = [];

    for (int i = 0; i < actualAvatars; i++) {
      avatars.insert(
        0,
        Positioned(
          left: i * (avatarSize - spacing),
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize / 2),
              child: imageUrls[i].isEmpty
                  ? _placeholderImage(width: avatarSize, height: avatarSize)
                  : OXCachedNetworkImage(
                      imageUrl: imageUrls[i],
                      fit: BoxFit.cover,
                      width: avatarSize,
                      height: avatarSize,
                      errorWidget: (context, url, error) => _placeholderImage(),
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
}
