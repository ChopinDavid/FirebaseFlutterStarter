import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_flutter_starter/models/firebase_flutter_starter_user.dart';
import 'package:firebase_flutter_starter/services/firestore_service.dart';
import 'package:firebase_flutter_starter/services/shared_preferences_service.dart';
import 'package:firebase_flutter_starter/services/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import '../test_data.dart' as testData;

void main() {
  late FirestoreService testObject;
  late FirebaseStorage mockFirebaseStorage;
  final String expectedUid = '123';
  final FirebaseFlutterStarterUser expectedUser =
      testData.firebaseFlutterStarterUser(
          uid: expectedUid,
          profilePictureUrl:
              'https://firebasestorage.googleapis.com/$expectedUid');
  final File profilePicture = File('test_resources/flutterFire.png');

  setUp(() async {
    testObject = FirestoreService(firebaseFirestore: FakeFirebaseFirestore());
    mockFirebaseStorage = MockFirebaseStorage();

    SharedPreferences.setMockInitialValues({});
    GetIt.instance.registerSingleton<SharedPreferences>(
        await SharedPreferences.getInstance());
    GetIt.instance.registerSingleton<SharedPreferencesService>(
        SharedPreferencesService());
    GetIt.instance.registerSingleton<StorageService>(
        StorageService(firebaseStorage: mockFirebaseStorage));
  });

  test('createUser works', () async {
    await testObject.createUser(
      uid: expectedUser.uid,
      firstName: expectedUser.firstName,
      lastName: expectedUser.lastName,
      email: expectedUser.email,
      profilePicture: profilePicture,
    );

    final FirebaseFlutterStarterUser? resultRemoteUser =
        await testObject.getUser(uid: expectedUser.uid);
    expect(resultRemoteUser, expectedUser);

    final FirebaseFlutterStarterUser? resultLocalUser =
        await GetIt.instance.get<SharedPreferencesService>().getCurrentUser();
    expect(resultLocalUser, expectedUser);
  });
}
