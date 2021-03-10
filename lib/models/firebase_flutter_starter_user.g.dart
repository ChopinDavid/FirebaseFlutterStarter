// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_flutter_starter_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseFlutterStarterUser _$FirebaseFlutterStarterUserFromJson(
    Map<String, dynamic> json) {
  return FirebaseFlutterStarterUser(
    uid: json['uid'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'] as String,
    profilePictureUrl: json['profilePictureUrl'] as String?,
  );
}

Map<String, dynamic> _$FirebaseFlutterStarterUserToJson(
        FirebaseFlutterStarterUser instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'profilePictureUrl': instance.profilePictureUrl,
    };
