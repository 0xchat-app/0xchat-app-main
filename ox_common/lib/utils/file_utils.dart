
import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pick_or_save/pick_or_save.dart';

import '../ox_common.dart';

class FileUtils {
  static Future<void> unzip(String zipPath,String unzipPath) async{

    if(await File(zipPath).exists()){
      // Read the Zip file from disk.
      final bytes = File(zipPath).readAsBytesSync();

      // Decode the Zip file
      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File _file = File(unzipPath+'/' + filename);
          await _file.create(recursive: true);
          await _file.writeAsBytes(data);
        } else {
          Directory _dir = Directory(unzipPath+'/' + filename);
          await _dir.create(recursive: true);
        }
      }
    }

  }

  static void createFolder(String folderPath) {
    Directory folder = Directory(folderPath);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
      print('Folder created: $folderPath');
    } else {
      print('Folder already exists: $folderPath');
    }
  }

  static File createFolderAndFile(String folderPath, String fileName) {
    Directory folder = Directory(folderPath);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
      print('Folder created: $folderPath');
    } else {
      print('Folder already exists: $folderPath');
    }

    File file = File('$folderPath/$fileName');
    if (!file.existsSync()) {
      file.createSync();
      print('File created: $fileName');
    } else {
      print('File already exists: $fileName');
    }
    return file;
  }

  static void _exportFileIOS(String filePath) {
    if (!Platform.isIOS) {
      throw Exception('exportFileIOS is only available on iOS');
    }
    OXCommon.channel.invokeMethod('exportFile', {'filePath': filePath});
  }

  static Future<bool> _exportFileAndroid(String filePath, [String? fileName]) async {
    final _pickOrSavePlugin = PickOrSave();
    final params = FileSaverParams(
      saveFiles: [
        SaveFileInfo(
          fileName: fileName,
          filePath: filePath,
        ),
      ],
    );
    List<String>? result;
    try {
      result = await _pickOrSavePlugin.fileSaver(params: params);
    } on PlatformException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }

    return result?.isNotEmpty ?? false;
  }

  static Future<String> _importFileIOS() async {
    if (!Platform.isIOS) {
      throw Exception('importFileIOS is only available on iOS');
    }
    return await OXCommon.channel.invokeMethod<String>('importFile') ?? '';
  }

  static Future<File?> importFile() async {
    if (Platform.isAndroid) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        return File(result.files.single.path!);
      }
    } else if (Platform.isIOS) {
      final filePath = await FileUtils._importFileIOS();
      if (filePath.isNotEmpty) {
        return File(filePath);
      }
    }
    return null;
  }

  static FutureOr<bool?> exportFile(String filePath, [String? fileName]) async {
    if (Platform.isIOS) {
      _exportFileIOS(filePath);
      return null;
    } else if (Platform.isAndroid) {
      return await _exportFileAndroid(filePath, fileName);
    }
    return false;
  }
}