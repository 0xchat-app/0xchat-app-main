import 'nostr_build_uploader.dart';
import 'pomf2_lain_la.dart';
import 'blossom_uploader.dart';
import 'nip96_uploader.dart';
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

class Uploader {
  static int NIP95_MAX_LENGTH = 80000;

  static String getFileType(String filePath) {
    var fileType = lookupMimeType(filePath);
    if (StringUtil.isBlank(fileType)) {
      fileType = "image/jpeg";
    }

    return fileType!;
  }

  static Future<String?> upload(
    String localPath,
    String imageService, {
    String? imageServiceAddr,
    String? fileName,
    Function(double progress)? onProgress,
  }) async {
    try{
      switch (imageService) {
        case ImageServices.POMF2_LAIN_LA:
          return await Pomf2LainLa.upload(localPath, fileName: fileName, onProgress: onProgress);
        case ImageServices.NOSTR_BUILD:
          return await NostrBuildUploader.upload(localPath, fileName: fileName, onProgress: onProgress);
        case ImageServices.NOSTO_RE:
          return await BolssomUploader.upload("https://nosto.re/", localPath,
              fileName: fileName, onProgress: onProgress);
        case ImageServices.BLOSSOM:
          if (StringUtil.isNotBlank(imageServiceAddr)) {
            return await BolssomUploader.upload(imageServiceAddr!, localPath,
                fileName: fileName, onProgress: onProgress);
          }
        case ImageServices.VOID_CAT:
          return await VoidCatUploader.upload(localPath, onProgress: onProgress);
        case ImageServices.NIP_96:
          if (StringUtil.isNotBlank(imageServiceAddr)) {
            return await NIP96Uploader.upload(imageServiceAddr!, localPath,
                fileName: fileName, onProgress: onProgress);
          }
        default:
          return await NIP96Uploader.upload(imageServiceAddr!, localPath, fileName: fileName, onProgress: onProgress);
      }
    } catch (e) {
      rethrow;
    }
  }
}
