import 'dart:convert';

import 'package:firebase_flutter_starter/models/firebase_flutter_starter_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<bool> storeCurrentUser(
      {required FirebaseFlutterStarterUser user}) async {
    final SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return await _sharedPreferences.setString(
        'current_user_json', jsonEncode(user.toJson()));
  }

  Future<FirebaseFlutterStarterUser?> getCurrentUser() async {
    final SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    final String? userAsJsonString =
        _sharedPreferences.getString('current_user_json');
    if (userAsJsonString != null) {
      final Map<String, dynamic> userAsJsonMap = jsonDecode(userAsJsonString);
      return FirebaseFlutterStarterUser.fromJson(userAsJsonMap);
    }
    return null;
  }
}
