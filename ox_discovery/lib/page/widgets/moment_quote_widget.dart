import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';

import 'package:ox_discovery/page/widgets/moment_widget.dart';
import 'package:ox_module_service/ox_module_service.dart';

import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../moments/moments_page.dart';
import 'moment_rich_text_widget.dart';

class MomentQuoteWidget extends StatefulWidget {
  final String notedId;

  const MomentQuoteWidget({super.key, required this.notedId});

  @override
  MomentQuoteWidgetState createState() => MomentQuoteWidgetState();
}

class MomentQuoteWidgetState extends State<MomentQuoteWidget> {
  NotedUIModel? notedUIModel;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedId != oldWidget.notedId) {
      setState(() {
        notedUIModel = null;
      });
      _initData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return quoteMoment();
  }

  void _initData() async {
    String notedId = widget.notedId;
    if (NotedUIModelCache.map[notedId] == null) {
      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(notedId);
      if (note == null) return;
      NotedUIModel newNotedModel = NotedUIModel(noteDB: note);
      NotedUIModelCache.map[notedId] = newNotedModel;
    }

    notedUIModel = NotedUIModelCache.map[notedId];
    _getMomentUserInfo(NotedUIModelCache.map[notedId]!);
    if (mounted) {
      setState(() {});
    }
  }

  void _getMomentUserInfo(NotedUIModel model)async {
    String pubKey = model.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
    if(mounted){
      setState(() {});
    }
  }



  Widget _getImageWidget() {
    NotedUIModel? model = notedUIModel;
    if (model == null) return const SizedBox();
    List<String> _getImagePathList = model.getImageList;
    if (_getImagePathList.isEmpty) return const SizedBox();
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(11.5.px),
        topRight: Radius.circular(11.5.px),
      ),
      child: Container(
        height: 172.px,
        color: ThemeColor.color100,
        child: OXCachedNetworkImage(
          imageUrl: _getImagePathList[0],
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              MomentWidgetsUtils.badgePlaceholderContainer(
                  height: 172, width: double.infinity),
          errorWidget: (context, url, error) =>
              MomentWidgetsUtils.badgePlaceholderContainer(
                  size: 172, width: double.infinity),
          height: 172.px,
        ),
      ),
    );
  }

  Widget quoteMoment() {
    NotedUIModel? model = notedUIModel;
    if (model == null) return MomentWidgetsUtils.emptyNoteMomentWidget(null,200);
    String pubKey = model.noteDB.author;
    return GestureDetector(
      onTap: () {
        OXNavigator.pushPage(context,
            (context) => MomentsPage(notedUIModel: ValueNotifier(model)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.px),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.px,
            color: ThemeColor.color160,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              11.5.px,
            ),
          ),
        ),
        child: Column(
          children: [
            _getImageWidget(),
            ValueListenableBuilder<UserDB>(
                valueListenable: Account.sharedInstance.getUserNotifier(pubKey),
                builder: (context, value, child) {
                  return Container(
                    padding: EdgeInsets.all(12.px),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await OXModuleService.pushPage(
                                    context, 'ox_chat', 'ContactUserInfoPage', {
                                  'pubkey': pubKey,
                                });
                                setState(() {});
                              },
                              child: MomentWidgetsUtils.clipImage(
                                borderRadius: 40.px,
                                imageSize: 40.px,
                                child: OXCachedNetworkImage(
                                  imageUrl: value.picture ?? '',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      MomentWidgetsUtils
                                          .badgePlaceholderImage(),
                                  errorWidget: (context, url, error) =>
                                      MomentWidgetsUtils
                                          .badgePlaceholderImage(),
                                  width: 40.px,
                                  height: 40.px,
                                ),
                              ),
                            ),
                            Text(
                              value.name ?? '--',
                              style: TextStyle(
                                fontSize: 12.px,
                                fontWeight: FontWeight.w500,
                                color: ThemeColor.color0,
                              ),
                            ).setPadding(
                              EdgeInsets.symmetric(
                                horizontal: 4.px,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                DiscoveryUtils.getUserMomentInfo(
                                    value, model.createAtStr)[0],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.px,
                                  fontWeight: FontWeight.w400,
                                  color: ThemeColor.color120,
                                ),
                              ),
                            ),
                          ],
                        ).setPaddingOnly(bottom: 4.px),
                        MomentRichTextWidget(
                          text: model.noteDB.content,
                          textSize: 14.px,
                          // maxLines: 1,
                          isShowAllContent: false,
                          clickBlankCallback: () => _jumpMomentPage(model),
                          showMoreCallback: () => _jumpMomentPage(model),
                        ),
                      ],
                    ),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }

  void _jumpMomentPage(NotedUIModel model)async {
      OXNavigator.pushPage(
          context, (context) => MomentsPage(notedUIModel: ValueNotifier(model)));
      setState(() {});
  }
}