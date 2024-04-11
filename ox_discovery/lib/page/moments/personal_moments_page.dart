import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/enum/moment_enum.dart';
import 'package:ox_discovery/page/widgets/horizontal_scroll_widget.dart';
import 'package:ox_discovery/page/widgets/moment_option_widget.dart';
import 'package:ox_discovery/page/widgets/nine_palace_grid_picture_widget.dart';
import 'package:ox_discovery/utils/moment_rich_text.dart';
import 'package:ox_localizable/ox_localizable.dart';

class PersonMomentsPage extends StatefulWidget {
  const PersonMomentsPage({super.key});

  @override
  State<PersonMomentsPage> createState() => _PersonMomentsPageState();
}

class _PersonMomentsPageState extends State<PersonMomentsPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: ThemeColor.color190,
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            _buildAppBar(),
            SliverToBoxAdapter(
              child: _buildNewMomentTips(),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 24.px),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return _buildMomentItem(
                      EMomentType.values[index % EMomentType.values.length]);
                }, childCount: 50),
              ),
            ),
          ],
        )
    );
  }

  Widget _buildAppBar(){
    return ExtendedSliverAppbar(
      toolBarColor: Colors.transparent,
      leading: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: CommonImage(
          iconName: "icon_back_left_arrow.png",
          width: 24.px,
          height: 24.px,
          useTheme: true,
        ),
        onPressed: () {
          OXNavigator.pop(context);
        },
      ),
      background: Container(
        color: ThemeColor.color190,
        height: 310.px,
        child: Stack(
          children: <Widget>[
            _buildCoverImage(),
            _buildUserInfo(),
          ],
        ),
      ),
      actions: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => _buildBottomDialog());
        },
        child: CommonImage(
          iconName: 'icon_more_operation.png',
          width: 24.px,
          height: 24.px,
          package: 'ox_discovery',
        ).setPaddingOnly(right: 24.px),
      ),
    );
  }

  Widget _buildCoverImage() {
    final placeholder = _placeholderImage(iconName: 'icon_group_default.png');

    return SizedBox(
      height: 240.px,
      width: double.infinity,
      child: OXCachedNetworkImage(
        imageUrl: 'https://nostr-chat-bucket.oss-cn-hongkong.aliyuncs.com/ipa/persion_monent.png',
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildUserInfo(){
    return Positioned(
      top: 210.px,
      right: 0,
      left: 0,
      height: 100.px,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.px),
        color: Colors.transparent,
        child: Stack(
          children: [
            _buildAvatar(
              imageUrl: 'https://nostr-chat-bucket.oss-cn-hongkong.aliyuncs.com/ipa/avatar.png',
              size: Size(80.px, 80.px),
              placeholderIconName: 'icon_user_default.png',
            ),
            Positioned(
              left: 92.px,
              bottom: 31.px,
              child: Text(
                'Kumakiki',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.px,
                  color: ThemeColor.color0,
                  height: 28.px / 20.px,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar({
    required String imageUrl,
    required Size size,
    required String placeholderIconName,
  }) {
    final placeholder = _placeholderImage(iconName: placeholderIconName);

    return ClipOval(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: OXCachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => placeholder,
          errorWidget: (context, url, error) => placeholder,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMomentItem(EMomentType type) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12.px,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          MomentRichText(
            text:
            "#0xchat it's worth noting that Satoshi Nakamoto's true identity remains unknown, and there is no publicly @Satoshi \nhttps://www.0xchat.com \nRead More",
          ),
          _momentTypeWidget(type),
          MomentOptionWidget(),
          // _momentOptionWidget()
        ],
      ),
    );
  }

  Widget _buildTitle(){
    return SizedBox(
      height: 34.px,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '28 Sep',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.px),
          ),
          const Spacer(),
          CommonImage(
            iconName: 'more_moment_icon.png',
            size: 20.px,
            package: 'ox_discovery',
          ),
        ],
      ),
    );
  }

  Widget _momentTypeWidget(EMomentType type) {
    Widget contentWidget = const SizedBox(width: 0);
    switch (type) {
      case EMomentType.picture:
        contentWidget = NinePalaceGridPictureWidget(
          imageList: [],
          width: 248.px,
          addImageCallback: (list){},
        ).setPadding(EdgeInsets.only(bottom: 12.px));
        break;
      case EMomentType.quote:
        contentWidget = HorizontalScrollWidget();
        break;
      case EMomentType.video:
        contentWidget = Container(
          margin: EdgeInsets.only(
            bottom: 12.px,
          ),
          decoration: BoxDecoration(
            color: ThemeColor.color100,
            borderRadius: BorderRadius.all(
              Radius.circular(
                Adapt.px(12),
              ),
            ),
          ),
          width: 210.px,
          height: 154.px,
        );
        break;
      case EMomentType.content:
        break;
    }
    return contentWidget;
  }

  Widget _buildNewMomentTips() {
    return GestureDetector(
      onTap: () {},
      child: UnconstrainedBox(
        child: Container(
          height: 40.px,
          padding: EdgeInsets.symmetric(
            horizontal: 12.px,
          ),
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.circular(22.px),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(
                imageUrl: 'https://nostr-chat-bucket.oss-cn-hongkong.aliyuncs.com/ipa/avatar.png',
                size: Size(26.px, 26.px),
                placeholderIconName: 'icon_user_default.png',
              ),
              SizedBox(width: 8.px,),
              Text(
                '2 replies',
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: 14.px,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ).setPaddingOnly(bottom: 12.px),
      ),
    );
  }

  Image _placeholderImage({required String iconName, Size? size}) {
    return Image.asset(
      'assets/images/$iconName',
      fit: BoxFit.cover,
      width: size?.width,
      height: size?.height,
      package: 'ox_common',
    );
  }

  Widget _buildBottomDialog(){
    List<String> options = ['Notifications','Change Cover'];
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(12.px),right: Radius.circular(12.px)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) => _buildButton(label: options[index]),
            separatorBuilder: (context, index) => Container(height: 0.5.px, color: ThemeColor.color160,),
            itemCount: options.length,
          ),
          Container(width:double.infinity,height: 8.px,color: ThemeColor.color190,),
          _buildButton(label: Localized.text('ox_wallet.cancel'),onTap: () => OXNavigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildButton({required String label,Color? color, VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: 56.px,
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w400,color: color ?? ThemeColor.color0),),
      ),
    );
  }
}
