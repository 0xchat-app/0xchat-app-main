
import 'dart:io';

import 'package:archive/archive.dart';


class FileUtils{


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
}