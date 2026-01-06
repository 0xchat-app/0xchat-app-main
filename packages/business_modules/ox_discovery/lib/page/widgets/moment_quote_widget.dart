import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/page/widgets/reply_contact_widget.dart';

import 'package:ox_module_service/ox_module_service.dart';

import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../moments/moments_page.dart';
import 'moment_rich_text_widget.dart';
import 'package:nostr_core_dart/nostr.dart';

class MomentQuoteWidget extends StatefulWidget {
  final String? neventId;
  final String? notedId;
  final List<String>? relays;

  const MomentQuoteWidget({super.key, this.notedId, this.relays, this.neventId});

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
    if (widget.notedId != oldWidget.notedId || widget.neventId != oldWidget.neventId) {
      setState(() {
        notedUIModel = null;
      });
      _initData();
    }
    if (notedUIModel == null) {
      _initData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return quoteMoment();
  }

  void _initData() async {
    String? notedId = widget.notedId;
    String? neventId = widget.neventId;

    if (neventId != null) {
      Map result = Nip19.decodeShareableEntity(Nip21.decode(neventId)!);
      String notedId = result['special'];

      NotedUIModel? neventIdNotifier = OXMomentCacheManager.getValueNotifierNoteToCache(notedId);

      if (neventIdNotifier != null) {
        notedUIModel = neventIdNotifier;
      } else {

        NoteDBISAR? note = await Moment.sharedInstance.loadNoteWithNevent(neventId);
        if (note == null) return;

        neventIdNotifier = NotedUIModel(noteDB: note);

        notedUIModel = neventIdNotifier;
      }

      _getMomentUserInfo(notedUIModel!);
      if (mounted) {
        setState(() {});
      }
      return;
    }

    if (notedId != null) {
      NotedUIModel? notedIdNotifier = OXMomentCacheManager.getValueNotifierNoteToCache(notedId);
      if(notedIdNotifier != null){
        notedUIModel = notedIdNotifier;
      }else{
        NotedUIModel? noteNotifier = await OXMomentCacheManager.getValueNotifierNoted(notedId,setRelay: widget.relays);
        if(noteNotifier == null) return;
        notedUIModel = noteNotifier;
      }

      _getMomentUserInfo(notedUIModel!);
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _getMomentUserInfo(NotedUIModel? modelNotifier) async {
    if(modelNotifier == null) return;
    String pubKey = modelNotifier.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
    if (mounted) {
      setState(() {});
    }
  }

  Widget _getImageWidget() {
    NotedUIModel? modelNotifier = notedUIModel;
    if (modelNotifier == null) return const SizedBox();
    List<String> _getImagePathList = modelNotifier.getImageList;
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

  Widget _showReplyContactWidget() {
    NotedUIModel? modelNotifier = notedUIModel;
    if (modelNotifier == null || modelNotifier == null) return const SizedBox();
    String replyId = modelNotifier.noteDB.getReplyId ?? '';
    if(replyId.isEmpty) return const SizedBox();
    return ReplyContactWidget(notedUIModel: notedUIModel);
  }

  Widget quoteMoment() {
    NotedUIModel? modelNotifier = notedUIModel;
    if (modelNotifier == null || modelNotifier == null) {
      return MomentWidgetsUtils.emptyNoteMomentWidget(null, 100);
    }

    String pubKey = modelNotifier.noteDB.author;
    return GestureDetector(
      onTap: () {
        OXNavigator.pushPage(context, (context) => MomentsPage(notedUIModel: modelNotifier));
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
            ValueListenableBuilder<UserDBISAR>(
              valueListenable: Account.sharedInstance.getUserNotifier(pubKey),
              builder: (context, value, child) {
                return Container(
                  padding: EdgeInsets.all(12.px),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                    MomentWidgetsUtils.badgePlaceholderImage(),
                                errorWidget: (context, url, error) =>
                                    MomentWidgetsUtils.badgePlaceholderImage(),
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
                                  value, modelNotifier.createAtStr)[0],
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
                      _showReplyContactWidget(),
                      MomentRichTextWidget(
                        text: modelNotifier.noteDB.content,
                        textSize: 14.px,
                        // maxLines: 1,
                        isShowAllContent: false,
                        clickBlankCallback: () => _jumpMomentPage(modelNotifier),
                        showMoreCallback: () => _jumpMomentPage(modelNotifier),
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

  void _jumpMomentPage(NotedUIModel? modelNotifier) async {
    OXNavigator.pushPage(context, (context) => MomentsPage(notedUIModel: modelNotifier));
  }
}
