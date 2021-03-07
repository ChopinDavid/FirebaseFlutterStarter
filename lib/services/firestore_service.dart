import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Future<void> createUser({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    var a =
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    });
    return a;
  }
}
