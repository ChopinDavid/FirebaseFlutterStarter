import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<TaskSnapshot> uploadImage({
    required File image,
    required String path,
  }) async {
    return await FirebaseStorage.instance.ref(path).putFile(image);
  }
}
