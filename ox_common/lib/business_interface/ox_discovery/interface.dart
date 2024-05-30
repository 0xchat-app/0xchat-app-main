import 'package:flutter/cupertino.dart';
import '../../utils/custom_uri_helper.dart';

class OXDiscoveryInterface {
  static const moduleName = 'ox_discovery';

  static void openMomentPage(
    BuildContext? context, {
    required String notedId,
  }) {
    String link = CustomURIHelper.createModuleActionURI(
      module: 'ox_discovery',
      action: 'momentPage',
      params: {'noteId': notedId},
    );
    link.tryHandleCustomUri(context: context);
  }
}
