import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter_starter/services/storage_service.dart';
import 'package:get_it/get_it.dart';

class FirestoreService {
  Future<void> createUser({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    File? profilePicture,
  }) async {
    String? _profilePictureDownloadUrl;
    if (profilePicture != null) {
      _profilePictureDownloadUrl = await GetIt.instance
          .get<StorageService>()
          .uploadImage(image: profilePicture, path: userId)
          .then((snapshot) => snapshot.ref.getDownloadURL());
    }
    Map<String, String> dataMap = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
    if (_profilePictureDownloadUrl != null) {
      dataMap['profilePictureUrl'] = _profilePictureDownloadUrl;
    }
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(dataMap);
  }
}
