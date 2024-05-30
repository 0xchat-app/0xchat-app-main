import '../../utils/custom_uri_helper.dart';

class OXDiscoveryInterface {
  static const moduleName = 'ox_discovery';

  static String getJumpMomentPageUri(String notedId) {
    String link = CustomURIHelper.createModuleActionURI(
      module: 'ox_discovery',
      action: 'momentPage',
      params: {'noteId': notedId},
    );
    return link;
  }
}
