
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';
import 'package:dio/dio.dart';
import 'package:ox_common/network/network_general.dart';
import 'package:ox_common/utils/aes_encrypt_utils.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_network/network_manager.dart';
import 'package:path_provider/path_provider.dart';

enum UplodAliyunType {
  imageType,
  voiceType,
  videoType,
}

class UplodAliyun {
  static Future<String> uploadFileToAliyun({BuildContext? context, params, String? encryptedKey, required UplodAliyunType fileType, required File file, required String filename}) async {
    File? encryptedFile;
    if(encryptedKey != null) {
      String directoryPath = '';
      if (Platform.isAndroid) {
        Directory? externalStorageDirectory = await getExternalStorageDirectory();
        if (externalStorageDirectory == null) {
          CommonToast.instance.show(context, 'Storage function abnormal');
          return Future.value('');
        }
        directoryPath = externalStorageDirectory.path;
      } else if (Platform.isIOS) {
        Directory temporaryDirectory = await getTemporaryDirectory();
        directoryPath = temporaryDirectory.path;
      }
      encryptedFile = FileUtils.createFolderAndFile(directoryPath + "/encrytedfile", filename);
      AesEncryptUtils.encryptFile(file, encryptedFile, encryptedKey);
      file = encryptedFile;
    }
    return OXNetwork.instance
        .doRequest(
      context,
      url: 'https://www.0xchat.com/nostrchat/oss/getSts',
      showErrorToast: true,
      needCommonParams: false,
      needRSA: false,
      type: RequestType.GET,
    )
        .then((OXResponse response) async {
      OXLoading.show();
      Map<String, dynamic> dataMap = Map<String, dynamic>.from(response.data);
      // LogUtil.e("upload : ${response}");
      // LogUtil.e('upload : ${dataMap}');
      Client.init(
        ossEndpoint: CommonConstant.ossEndPoint,
        bucketName: CommonConstant.ossBucketName,
        authGetter: () => _authGetter(authMap: dataMap),
      );
      String uri = await uploadFile(file.path, fileType, filename);
      OXLoading.dismiss();
      return uri;
      // return false;
    }).catchError((e) {
      LogUtil.e("what:$e");
      return '';
    });
  }

  static Auth _authGetter({required Map<String, dynamic> authMap}) {
    String secureToken = AesEncryptUtils.aes128Decrypt(authMap['encryptStsToken']);
    LogUtil.e("secureToken : $secureToken");
    return Auth(
      accessKey: authMap['accessKeyId'],
      accessSecret: authMap['accessKeySecret'],
      expire: authMap['expiration'],
      secureToken: secureToken,
    );
  }

  static Future<String> uploadFile(String filepath, UplodAliyunType fileType, String filename) async {
    Response<dynamic> resp = await Client().putObjectFile(
      filepath,
      option: PutRequestOption(
        onSendProgress: (count, total) {
          print("send: count = $count, and total = $total");
        },
        onReceiveProgress: (count, total) {
          print("receive: count = $count, and total = $total");
        },
        override: true,
        aclModel: AclMode.publicRead,
        callback: Callback(
          callbackUrl: "https://www.0xchat.com/nostrchat/oss/callback",
          callbackBody: "{\"mimeType\":\${mimeType}, \"filepath\":\${object},\"size\":\${size},\"bucket\":\${bucket},\"phone\":\${x:phone}}",
          calbackBodyType: CalbackBodyType.json,
        ),
      ),
      fileKey: "${getFileFolders(fileType)}${filename}",
    );

    LogUtil.e("resp : ${resp}");

    String uri = 'https://${CommonConstant.ossBucketName}.${CommonConstant.ossEndPoint}/${getFileFolders(fileType)}${filename}';
    return uri;
  }

  static String getFileFolders(UplodAliyunType fileType) {
    if (fileType == UplodAliyunType.imageType) {
      return 'images/';
    } else if (fileType == UplodAliyunType.videoType) {
      return 'video/';
    } else if (fileType == UplodAliyunType.voiceType) {
      return 'voice/';
    }
    return '';
  }
}
