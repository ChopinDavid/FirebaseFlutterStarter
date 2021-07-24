import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/screens/login_page.dart';
import 'package:firebase_flutter_starter/services/firestore_service.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks.dart';
import '../test_data.dart' as testData;
import '../test_utils.dart';

void main() {
  late NavigationService mockNavigationService;
  late FirebaseAuth mockFirebaseAuth;
  late FirestoreService mockFirestoreService;
  late SharedPreferencesService mockSharedPreferencesService;
  late SharedPreferences mockSharedPreferences;

  setUpAll(() async {
    TestUtils.setupCloudFirestoreMocks();
    await Firebase.initializeApp();
    TestUtils.registerFallbacks();
  });

  setUp(() async {
    await GetIt.instance.reset();

    mockNavigationService = MockNavigationService();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestoreService = MockFirestoreService();
    mockSharedPreferencesService = MockSharedPreferencesService();
    mockSharedPreferences = MockSharedPreferences();

    User mockUser = MockUser();
    UserCredential mockUserCredential = MockUserCredential();
    when(() => mockUser.uid).thenReturn('123');
    when(() => mockUserCredential.user).thenReturn(mockUser);

    when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((invocation) async => mockUserCredential);

    when(() => mockFirestoreService.getUser(uid: any(named: 'uid')))
        .thenAnswer((invocation) async => MockFirebaseFlutterStarterUser());

    when(() => mockSharedPreferencesService.storeCurrentUser(
        user: any(named: 'user'))).thenAnswer((invocation) async => true);

    GetIt.instance.registerSingleton<NavigationService>(mockNavigationService);
    GetIt.instance.registerSingleton<FirebaseAuth>(mockFirebaseAuth);
    GetIt.instance.registerSingleton<FirestoreService>(mockFirestoreService);
    GetIt.instance.registerSingleton<SharedPreferencesService>(
        mockSharedPreferencesService);
    GetIt.instance.registerSingleton<SharedPreferences>(mockSharedPreferences);
  });

  group('Form validation', () {
    group('Email field', () {
      testWidgets(
          'Shows "Please enter an email address..." if the user fails to enter an email address and clicks on the "Login" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginPage()));

        final Finder loginButtonFinder = find.byKey(Key('login-button-key'));
        await tester.ensureVisible(loginButtonFinder);
        await tester.tap(loginButtonFinder);

        await tester.ensureVisible(find.byKey(Key('email-field')));
        await tester.pumpAndSettle();
        expect(find.text('Please enter an email address...'), findsOneWidget);
      });

      testWidgets(
          'Shows "Please enter a valid email address..." if the user fails to enter an email address and clicks on the "Login" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginPage()));

        await tester.enterText(
            find.byKey(Key('email-field')), 'leo!tolstoy.com');

        final Finder loginButtonFinder = find.byKey(Key('login-button-key'));
        await tester.ensureVisible(loginButtonFinder);
        await tester.tap(loginButtonFinder);

        await tester.ensureVisible(find.byKey(Key('email-field')));
        await tester.pumpAndSettle();
        expect(
            find.text('Please enter a valid email address...'), findsOneWidget);
      });

      testWidgets(
          'Does not show "Please enter an email address..." or "Please enter a valid email address..." if the user enters a valid email address and clicks on the "Login" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginPage()));

        await tester.enterText(
            find.byKey(Key('email-field')), 'leo@tolstoy.com');

        final Finder loginButtonFinder = find.byKey(Key('login-button-key'));
        await tester.ensureVisible(loginButtonFinder);
        await tester.tap(loginButtonFinder);

        await tester.ensureVisible(find.byKey(Key('email-field')));
        await tester.pumpAndSettle();
        expect(find.text('Please enter an email address...'), findsNothing);
        expect(
            find.text('Please enter a valid email address...'), findsNothing);
      });
    });
  });

  group('Login button', () {
    testWidgets('Successfully logging in pushes the home screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.enterText(find.byKey(Key('email-field')), 'leo@tolstoy.com');
      await tester.enterText(find.byKey(Key('password-field')), 'Novels9@');

      final Finder loginButtonFinder = find.byKey(Key('login-button-key'));
      await tester.ensureVisible(loginButtonFinder);
      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle();

      verify(() => mockNavigationService.pushNamed(Routes.TABBAR));
    });

    testWidgets('Unsuccessfully logging in displays',
        (WidgetTester tester) async {
      when(() => mockFirestoreService.getUser(
            uid: any(named: 'uid'),
          )).thenThrow(testData.firebaseAuthException());

      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.enterText(find.byKey(Key('email-field')), 'leo@tolstoy.com');
      await tester.enterText(
          find.byKey(Key('password-field')), 'Incorrectpassword');

      final Finder loginButtonFinder = find.byKey(Key('login-button-key'));
      await tester.ensureVisible(loginButtonFinder);
      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byKey(Key('error-dialog')), findsOneWidget);
    });
  });
}
