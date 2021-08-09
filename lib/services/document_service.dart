import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class DocumentService {
  Future<String> _getFilePath({required String relativePath}) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/$relativePath';

    return filePath;
  }

  Future<FileSystemEntity?> deleteFile({required relativePath}) async {
    final String path = await _getFilePath(relativePath: relativePath);
    final File file = File(path);
    if (await file.exists()) {
      return file.delete();
    }
    return null;
  }

  Future<File> saveImageFromBytes(
      {required Uint8List bytes, required String relativePath}) async {
    String path = await _getFilePath(relativePath: relativePath);
    return await File(path).writeAsBytes(bytes);
  }

  Future<File> getImage({required String relativePath}) async {
    return File(await _getFilePath(relativePath: relativePath));
  }
}
