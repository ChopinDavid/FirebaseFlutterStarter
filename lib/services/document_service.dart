import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class DocumentService {
  Future<String> _getFilePath({required String relativePath}) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/$relativePath';

    return filePath;
  }

  Future<File> saveImage(
      {required PickedFile image, required String relativePath}) async {
    String path = await _getFilePath(relativePath: relativePath);
    imageCache!.clearLiveImages();
    return await File(path).writeAsBytes(await image.readAsBytes());
  }

  Future<File> getImage({required String relativePath}) async {
    return File(await _getFilePath(relativePath: relativePath));
  }
}
