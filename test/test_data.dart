import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_starter/models/firebase_flutter_starter_user.dart';

FirebaseFlutterStarterUser firebaseFlutterStarterUser({
  String uid = '123',
  String firstName = 'Leo',
  String lastName = 'Tolstoy',
  String email = 'leo@tolstoy.com',
  String profilePictureUrl =
      'https://www.biography.com/.image/t_share/MTE5NTU2MzI0OTQxMDA2MzQ3/leo-tolstoyjpg.jpg',
}) =>
    FirebaseFlutterStarterUser(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        profilePictureUrl: profilePictureUrl);

FirebaseAuthException firebaseAuthException({
  String? message,
  String code = '1',
  String email = 'leo@tolstoy.com',
  String phoneNumber = '1234567890',
  String tenantId = '123',
}) =>
    FirebaseAuthException(
      code: '1',
      email: email,
      phoneNumber: phoneNumber,
      message: message,
      tenantId: tenantId,
    );
