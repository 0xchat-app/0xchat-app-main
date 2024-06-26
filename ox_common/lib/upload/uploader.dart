import 'nostr_build_uploader.dart';
import 'pomf2_lain_la.dart';
import 'blossom_uploader.dart';
import 'nip96_uploader.dart';
import 'nostrfiles_dev_uploader.dart';
import 'void_cat.dart';
import 'package:mime/mime.dart';
import 'string_util.dart';

class ImageServices {
  static const NIP_96 = "NIP-96";
  static const BLOSSOM = "Blossom";
  static const NOSTR_BUILD = "nostr.build";
  static const NOSTRIMG_COM = "nostrimg.com";
  static const POMF2_LAIN_LA = "pomf2.lain.la";
  static const VOID_CAT = "void.cat";
  static const NOSTRFILES_DEV = "nostrfiles.dev";
  static const NOSTO_RE = "nosto.re";
}

enum FileServices {
  blossom('Blossom'),
  nostr_build('nostr.build'),
  nostr_img_com('nostrimg.com'),
  pomf2_lain_la('pomf2.lain.la'),
  void_cat('void.cat'),
  nostr_files_dev('nostrfiles.dev'),
  nosto_re('nosto.re');

  final String serviceName;

  const FileServices(this.serviceName);
}

class Uploader {
  static int NIP95_MAX_LENGTH = 80000;

  static String getFileType(String filePath) {
    var fileType = lookupMimeType(filePath);
    if (StringUtil.isBlank(fileType)) {
      fileType = "image/jpeg";
    }

    return fileType!;
  }

  static Future<String?> upload(String localPath, String imageService,
      {String? imageServiceAddr, String? fileName}) async {
    switch (imageService) {
      case ImageServices.POMF2_LAIN_LA:
        return await Pomf2LainLa.upload(localPath, fileName: fileName);
      case ImageServices.NOSTR_BUILD:
        return await NostrBuildUploader.upload(localPath, fileName: fileName);
      case ImageServices.NOSTO_RE:
        return await BolssomUploader.upload("https://nosto.re/", localPath,
            fileName: fileName);
      case ImageServices.BLOSSOM:
        if (StringUtil.isNotBlank(imageServiceAddr)) {
          return await BolssomUploader.upload(imageServiceAddr!, localPath,
              fileName: fileName);
        }
      case ImageServices.VOID_CAT:
        return await VoidCatUploader.upload(localPath);
      case ImageServices.NIP_96:
        if (StringUtil.isNotBlank(imageServiceAddr)) {
          return await NIP96Uploader.upload(imageServiceAddr!, localPath,
              fileName: fileName);
        }
      default:
        return await NostrBuildUploader.upload(localPath, fileName: fileName);
    }
  }
}
