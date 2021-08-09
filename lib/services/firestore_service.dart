import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter_starter/models/firebase_flutter_starter_user.dart';
import 'package:firebase_flutter_starter/services/shared_preferences_service.dart';
import 'package:firebase_flutter_starter/services/storage_service.dart';
import 'package:get_it/get_it.dart';

class FirestoreService {
  final FirebaseFirestore firebaseFirestore;
  FirestoreService({required this.firebaseFirestore});

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

    await GetIt.instance
        .get<SharedPreferencesService>()
        .storeCurrentUser(user: user);

    return await firebaseFirestore
        .collection('users')
        .doc(uid)
        .set(user.toJson());
  }

  Future<FirebaseFlutterStarterUser?> getUser({required String uid}) async {
    DocumentSnapshot querySnapshot =
        await firebaseFirestore.collection('users').doc(uid).get();
    if (querySnapshot.exists) {
      Map<String, dynamic> userDataMap =
          querySnapshot.data()! as Map<String, dynamic>;
      userDataMap['uid'] = uid;
      return FirebaseFlutterStarterUser.fromJson(userDataMap);
    }
    return null;
  }

  Future<void> deleteUser({required uid}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .delete();
  }

  Future<void> updateUserProfilePicture(
      {required String uid, required File profilePicture}) async {
    String _profilePictureDownloadUrl = await GetIt.instance
        .get<StorageService>()
        .uploadImage(image: profilePicture, path: uid)
        .then((snapshot) => snapshot.ref.getDownloadURL());

    return await firebaseFirestore
        .collection('users')
        .doc(uid)
        .update({'profilePictureUrl': _profilePictureDownloadUrl});
  }
}
