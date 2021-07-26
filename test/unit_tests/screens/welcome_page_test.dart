import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart'
    as FirebaseAuthMocks;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/screens/welcome_page.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import '../../test_utils.dart';

void main() {
  late NavigationService mockNavigationService;
  late FirebaseAuth mockFirebaseAuth;
  setUpAll(() async {
    TestUtils.setupCloudFirestoreMocks();
    await Firebase.initializeApp();
    TestUtils.registerFallbacks();
  });

  setUp(() async {
    await GetIt.instance.reset();

    mockNavigationService = MockNavigationService();
    mockFirebaseAuth = MockFirebaseAuth();

    GetIt.instance.registerSingleton<NavigationService>(mockNavigationService);
    GetIt.instance.registerSingleton<FirebaseAuth>(mockFirebaseAuth);
  });

  group('buttons', () {
    testWidgets('tapping login takes us to the login page',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: WelcomePage()));

      await tester.tap(find.byKey(Key('login-key')));

      verify(() => mockNavigationService.pushNamed(Routes.LOGIN));
    });

    testWidgets('tapping signup takes us to the signup page',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: WelcomePage()));

      await tester.tap(find.byKey(Key('signup-button-key')));

      verify(() => mockNavigationService.pushNamed(Routes.SIGNUP));
    });
  });

  group('auto-navigation', () {
    testWidgets('if currentUser is not null, pushes to the home page',
        (WidgetTester tester) async {
      when(() => mockFirebaseAuth.currentUser)
          .thenReturn(FirebaseAuthMocks.MockUser());
      await tester.pumpWidget(MaterialApp(home: WelcomePage()));

      await tester.pump();

      verify(() => mockNavigationService.pushNamed(Routes.TABBAR));
    });

    testWidgets('if currentUser is null, does not push to the home page',
        (WidgetTester tester) async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);
      await tester.pumpWidget(MaterialApp(home: WelcomePage()));

      await tester.pump();

      verifyNever(() => mockNavigationService.pushNamed(Routes.TABBAR));
    });
  });
}
