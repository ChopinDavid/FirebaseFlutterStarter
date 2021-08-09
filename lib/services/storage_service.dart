import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage firebaseStorage;
  StorageService({required this.firebaseStorage});

  Future<TaskSnapshot> uploadImage({
    required File image,
    required String path,
  }) async {
    return await firebaseStorage.ref(path).putFile(image);
  }
}
