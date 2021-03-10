import 'package:json_annotation/json_annotation.dart';

part 'firebase_flutter_starter_user.g.dart';

@JsonSerializable()
class FirebaseFlutterStarterUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePictureUrl;

  FirebaseFlutterStarterUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePictureUrl,
  });

  factory FirebaseFlutterStarterUser.fromJson(Map<String, dynamic> json) =>
      _$FirebaseFlutterStarterUserFromJson(json);
  Map<String, dynamic> toJson() => _$FirebaseFlutterStarterUserToJson(this);
}
