import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter_starter/models/firebase_flutter_starter_user.dart';
import 'package:firebase_flutter_starter/services/storage_service.dart';
import 'package:get_it/get_it.dart';

class FirestoreService {
  Future<void> createUser({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    File? profilePicture,
  }) async {
    String? _profilePictureDownloadUrl;
    if (profilePicture != null) {
      _profilePictureDownloadUrl = await GetIt.instance
          .get<StorageService>()
          .uploadImage(image: profilePicture, path: uid)
          .then((snapshot) => snapshot.ref.getDownloadURL());
    }
    final FirebaseFlutterStarterUser user = FirebaseFlutterStarterUser(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        profilePictureUrl: _profilePictureDownloadUrl);
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(user.toJson());
  }

  Future<FirebaseFlutterStarterUser?> getUser({required String uid}) async {
    DocumentSnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (querySnapshot.exists) {
      Map<String, dynamic> userDataMap = querySnapshot.data()!;
      userDataMap['uid'] = uid;
      return FirebaseFlutterStarterUser.fromJson(userDataMap);
    }
    return null;
  }
}
