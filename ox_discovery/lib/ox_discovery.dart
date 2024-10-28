import 'dart:async';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/page/discovery_page.dart';
import 'package:ox_discovery/page/moments/group_moments_page.dart';
import 'package:ox_discovery/page/moments/moments_page.dart';
import 'package:ox_discovery/page/moments/personal_moments_page.dart';
import 'package:ox_discovery/page/moments/public_moments_page.dart';
import 'package:ox_discovery/page/widgets/moment_rich_text_widget.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';

import 'model/moment_extension_model.dart';
import 'model/moment_ui_model.dart';

class OXDiscovery extends OXFlutterModule {
  @override
  Future<void> setup() async {
    await super.setup();
    OXMomentManager.sharedInstance.init();
    // ChatBinding.instance.setup();
  }

  @override
  // TODO: implement moduleName
  String get moduleName => 'ox_discovery';

  @override
  Map<String, Function> get interfaces => {
        'momentPage': jumpMomentPage,
        'momentRichTextWidget': momentRichTextWidget,
        'showPersonMomentsPage': showPersonMomentsPage,
      };

  @override
  Future<T?>? navigateToPage<T>(
      BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'PersonMomentsPage':
        return OXNavigator.pushPage(
            context, (context) => PersonMomentsPage(userDB: params?['userDB']));
      case 'GroupMomentsPage':
        return OXNavigator.pushPage(context,
            (context) => GroupMomentsPage(groupId: params?['groupId']));
      case 'jumpPublicMomentWidget':
        return OXNavigator.pushPage(context,
                (context) => PublicMomentsPage());
      case 'discoveryPageWidget':
        return OXNavigator.pushPage(context,
                (context) => DiscoveryPage(typeInt: params?['typeInt']));
    }
    return null;
  }


  Widget momentRichTextWidget(
    BuildContext context, {
    required String content,
    required int textSize,
    required bool isShowAllContent,
    Function? clickBlankCallback,
    Function? showMoreCallback,
  }) {
    return MomentRichTextWidget(
      text: content,
      textSize: textSize.px,
      // maxLines: 1,
      isShowAllContent: isShowAllContent,
      clickBlankCallback: clickBlankCallback,
      showMoreCallback: showMoreCallback,
    );
  }

  void jumpMomentPage(BuildContext? context, {required String noteId}) async {
    ValueNotifier<NotedUIModel?> notedUIModelNotifier =
        OXMomentCacheManager.getValueNotifierNoteToCache(noteId);
    if (notedUIModelNotifier.value != null) {
      OXNavigator.pushPage(
        context!,
        (context) => MomentsPage(
          isShowReply: false,
          notedUIModel: notedUIModelNotifier,
        ),
      );
      return;
    }

    ValueNotifier<NotedUIModel?> noteNotifier =
        await OXMomentCacheManager.getValueNotifierNoted(noteId);

    if (noteNotifier.value == null) {
      return CommonToast.instance.show(context, 'Note not found !');
    }

    OXNavigator.pushPage(
      context!,
      (context) => MomentsPage(
        isShowReply: false,
        notedUIModel: noteNotifier,
      ),
    );
  }


  Widget showPersonMomentsPage(BuildContext? context,
      {required UserDBISAR userDB}) {
    return PersonMomentsPage(
      userDB: userDB,
    );
  }
}
