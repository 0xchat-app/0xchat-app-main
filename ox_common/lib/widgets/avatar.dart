import 'dart:io';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_module_service/ox_module_service.dart';


class BaseAvatarWidget extends StatelessWidget {
  BaseAvatarWidget({
    required this.imageUrl,
    required this.defaultImageName,
    required this.size,
    this.isCircular = false,
    this.isClickable = false,
    this.onTap,
    this.onLongPress,
  });

  final String imageUrl;
  final String defaultImageName;
  final double size;
  final bool isCircular;
  final bool isClickable;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final radius = isCircular ? size : 5.0;
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      onLongPress: onLongPress,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: _buildAvatar(),
      ),
    );
  }


  Widget _buildAvatar() {
    if (imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        errorWidget: (context, url, error) => _defaultImage(defaultImageName, size),
        placeholder: (context, url) => _defaultImage(defaultImageName, size),
        fit: BoxFit.cover,
        imageUrl: imageUrl,
        width: size,
        height: size,
      );
    } else {
      return _defaultImage(defaultImageName, size);
    }
  }

  Image _defaultImage(String imageName, double size) => Image.asset(
    'assets/images/$imageName',
    fit: BoxFit.contain,
    width: size,
    height: size,
    package: 'ox_chat',
  );
}

class OXUserAvatar extends StatefulWidget {

  OXUserAvatar({
    this.user,
    this.imageUrl,
    double? size,
    this.isCircular = true,
    this.isClickable = false,
    this.onReturnFromNextPage,
    this.onLongPress,
  }) : this.size = size ?? Adapt.px(48);

  final UserDB? user;
  final String? imageUrl;
  final double size;
  final bool isCircular;
  final bool isClickable;
  final VoidCallback? onReturnFromNextPage;
  final GestureLongPressCallback? onLongPress;

  @override
  State<StatefulWidget> createState() => OXUserAvatarState();
}

class OXUserAvatarState extends State<OXUserAvatar> {

  final defaultImageName = 'icon_user_default.png';

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.user?.picture ?? widget.imageUrl ?? '';
    return BaseAvatarWidget(
      imageUrl: imageUrl,
      defaultImageName: defaultImageName,
      size: widget.size,
      isCircular: widget.isCircular,
      isClickable: widget.isClickable,
      onTap: () async {
        final user = widget.user;
        if (user == null) {
          CommonToast.instance.show(context, 'User not found');
          return ;
        }
        await OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
          'userDB': user,
        });
        final onReturnFromNextPage = widget.onReturnFromNextPage;
        if (onReturnFromNextPage != null) onReturnFromNextPage();
      },
      onLongPress: widget.onLongPress,
    );
  }
}


class OXChannelAvatar extends StatefulWidget {

  OXChannelAvatar({
    this.channel,
    this.imageUrl,
    double? size,
    this.isCircular = true,
    this.isClickable = false,
    this.onReturnFromNextPage,
  }) : this.size = size ?? Adapt.px(48);

  final ChannelDB? channel;
  final String? imageUrl;
  final double size;
  final bool isCircular;
  final bool isClickable;
  final VoidCallback? onReturnFromNextPage;

  @override
  State<StatefulWidget> createState() => OXChannelAvatarState();
}

class OXChannelAvatarState extends State<OXChannelAvatar> {

  final defaultImageName = 'icon_group_default.png';

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.channel?.picture ?? widget.imageUrl ?? '';
    return BaseAvatarWidget(
      imageUrl: imageUrl,
      defaultImageName: defaultImageName,
      size: widget.size,
      isCircular: widget.isCircular,
      isClickable: widget.isClickable,
      onTap: () async {
        final channel = widget.channel;
        final channelId = channel;
        if (channelId != null && channel != null) {
          await OXModuleService.pushPage(context, 'ox_chat', 'ContactChanneDetailsPage', {
            'channelDB': channel,
          });
          final onReturnFromNextPage = widget.onReturnFromNextPage;
          if (onReturnFromNextPage != null) onReturnFromNextPage();
        } else {
          CommonToast.instance.show(context, 'The Channel Detail load failed.');
        }
      },
    );
  }

}

class OXGroupAvatar extends StatefulWidget {

  OXGroupAvatar({
    this.group,
    this.imageUrl,
    double? size,
    this.isCircular = true,
    this.isClickable = false,
    this.onReturnFromNextPage,
  }) : this.size = size ?? Adapt.px(48);

  final GroupDB? group;
  final String? imageUrl;
  final double size;
  final bool isCircular;
  final bool isClickable;
  final VoidCallback? onReturnFromNextPage;

  @override
  State<StatefulWidget> createState() => OXGroupAvatarState();
}

class OXGroupAvatarState extends State<OXGroupAvatar> {

  final defaultImageName = 'icon_group_default.png';

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.group?.picture ?? widget.imageUrl ?? '';
    return BaseAvatarWidget(
      imageUrl: imageUrl,
      defaultImageName: defaultImageName,
      size: widget.size,
      isCircular: widget.isCircular,
      isClickable: widget.isClickable,
      onTap: () async {
        final group = widget.group;
        final channelId = group;
        // if (channelId != null && channel != null) {
        //   await OXModuleService.pushPage(context, 'ox_chat', 'ContactChanneDetailsPage', {
        //     'channelDB': channel,
        //   });
        //   final onReturnFromNextPage = widget.onReturnFromNextPage;
        //   if (onReturnFromNextPage != null) onReturnFromNextPage();
        // } else {
        //   CommonToast.instance.show(context, 'The Group Detail load failed.');
        // }
      },
    );
  }
}
