import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_flutter_starter/bloc/account_deletion_bloc.dart';
import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/models/firebase_flutter_starter_user.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'test_data.dart' as testData;

typedef Callback(MethodCall call);

class TestUtils {
  static void registerFallbacks() {
    registerFallbackValue<FirebaseFlutterStarterUser>(
        testData.firebaseFlutterStarterUser());
    registerFallbackValue<AuthState>(AuthInitial());
    registerFallbackValue<AuthEvent>(LoginUserWithEmailAndPassword(
        email: 'leo@tolstoy.com', password: 'Novels9@'));
    final NavigationService navigationService =
        NavigationService(navKey: GlobalKey<NavigatorState>());
    registerFallbackValue<NavigationService>(navigationService);
    registerFallbackValue<AccountDeletionState>(AccountDeletionInitial());
    registerFallbackValue<AccountDeletionEvent>(
        DeleteAccount(enteredPassword: 'Novels9@'));
  }

  static void setupCloudFirestoreMocks([Callback? customHandlers]) {
    TestWidgetsFlutterBinding.ensureInitialized();

    MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
      if (call.method == 'Firebase#initializeCore') {
        return [
          {
            'name': defaultFirebaseAppName,
            'options': {
              'apiKey': '123',
              'appId': '123',
              'messagingSenderId': '123',
              'projectId': '123',
            },
            'pluginConstants': {},
          }
        ];
      }

      if (call.method == 'Firebase#initializeApp') {
        return {
          'name': call.arguments['appName'],
          'options': call.arguments['options'],
          'pluginConstants': {},
        };
      }

      if (customHandlers != null) {
        customHandlers(call);
      }

      return null;
    });
  }
}
