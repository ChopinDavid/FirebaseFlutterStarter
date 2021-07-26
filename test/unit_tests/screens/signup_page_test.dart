import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/screens/signup_page.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/widgets/profile_picture.dart';
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

  group('Form validation', () {
    group('First Name field', () {
      testWidgets(
          'Shows "Please enter a first name..." if the user fails to enter a first name and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('first-name-field')));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a first name...'), findsOneWidget);
      });

      testWidgets(
          'Does not show "Please enter a first name..." if the user enters a first name and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(find.byKey(Key('first-name-field')), 'Leo');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('first-name-field')));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a first name...'), findsNothing);
      });
    });

    group('Last Name field', () {
      testWidgets(
          'Shows "Please enter a last name..." if the user fails to enter a last name and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('last-name-field')));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a last name...'), findsOneWidget);
      });

      testWidgets(
          'Does not show "Please enter a last name..." if the user enters a last name and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(find.byKey(Key('last-name-field')), 'Tolstoy');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('last-name-field')));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a last name...'), findsNothing);
      });
    });

    group('Email field', () {
      testWidgets(
          'Shows "Please enter an email address..." if the user fails to enter an email address and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('email-field')));
        await tester.pumpAndSettle();
        expect(find.text('Please enter an email address...'), findsOneWidget);
      });

      testWidgets(
          'Shows "Please enter a valid email address..." if the user fails to enter an email address and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(
            find.byKey(Key('email-field')), 'leo!tolstoy.com');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('email-field')));
        await tester.pumpAndSettle();
        expect(
            find.text('Please enter a valid email address...'), findsOneWidget);
      });

      testWidgets(
          'Does not show "Please enter an email address..." or "Please enter a valid email address..." if the user enters a valid email address and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(
            find.byKey(Key('email-field')), 'leo@tolstoy.com');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('email-field')));
        await tester.pumpAndSettle();
        expect(find.text('Please enter an email address...'), findsNothing);
        expect(
            find.text('Please enter a valid email address...'), findsNothing);
      });
    });

    group('Password field', () {
      testWidgets(
          'Shows "Please enter a password..." if the user fails to enter a password and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('password-field')));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a password...'), findsOneWidget);
      });

      testWidgets(
          'Shows "Password must have 1 uppercase character..." if the user fails to enter a password with an uppercase character and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(find.byKey(Key('password-field')), 'novels9@');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('password-field')));
        await tester.pumpAndSettle();
        expect(find.text('Password must have 1 uppercase character...'),
            findsOneWidget);
      });

      testWidgets(
          'Shows "Password must have 1 special character..." if the user fails to enter a password with a special character and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(find.byKey(Key('password-field')), 'Novels99');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('password-field')));
        await tester.pumpAndSettle();
        expect(find.text('Password must have 1 special character...'),
            findsOneWidget);
      });

      testWidgets(
          'Shows "Password must have 1 number..." if the user fails to enter a password with a number and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(find.byKey(Key('password-field')), 'Novels@@');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('password-field')));
        await tester.pumpAndSettle();
        expect(find.text('Password must have 1 number...'), findsOneWidget);
      });

      testWidgets(
          'Shows "Password must have at least 8 characters..." if the user fails to enter a password with at least 8 characters and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(find.byKey(Key('password-field')), 'Novel9@');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('password-field')));
        await tester.pumpAndSettle();
        expect(find.text('Password must have at least 8 characters...'),
            findsOneWidget);
      });

      testWidgets(
          'Shows "Password must have 1 uppercase character and at least 8 characters..." if the user fails to enter a password with an uppercase character and at least 8 characters and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(find.byKey(Key('password-field')), 'novel9@');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('password-field')));
        await tester.pumpAndSettle();
        expect(
            find.text(
                'Password must have 1 uppercase character and at least 8 characters...'),
            findsOneWidget);
      });

      testWidgets(
          'Shows "Password must have 1 uppercase character, 1 special character, and at least 8 characters..." if the user fails to enter a password with an uppercase character, a special character, and at least 8 characters and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(find.byKey(Key('password-field')), 'novel99');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('password-field')));
        await tester.pumpAndSettle();
        expect(
            find.text(
                'Password must have 1 uppercase character, 1 special character, and at least 8 characters...'),
            findsOneWidget);
      });
    });

    group('Confirm field', () {
      testWidgets(
          'Shows "Passwords must match..." if the user fails to enter matching emails and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(find.byKey(Key('password-field')), 'Novels9@');
        await tester.enterText(
            find.byKey(Key('confirm-password-field')), 'Novels9#');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('confirm-password-field')));
        await tester.pumpAndSettle();
        expect(find.text('Passwords must match...'), findsOneWidget);
      });

      testWidgets(
          'Does not show "Passwords must match..." if the user enters matching emails and clicks on the "Signup" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SignupPage()));

        await tester.enterText(find.byKey(Key('password-field')), 'Novels9@');
        await tester.enterText(
            find.byKey(Key('confirm-password-field')), 'Novels9@');

        final Finder signupButtonFinder = find.byKey(Key('signup-button-key'));
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);

        await tester.ensureVisible(find.byKey(Key('confirm-password-field')));
        await tester.pumpAndSettle();
        expect(find.text('Passwords must match...'), findsNothing);
      });
    });
  });

  group('Profile picture', () {
    testWidgets('Tapping profile picture brings up ImageSourceOverlay',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupPage()));

      await tester.tap(find.byType(ProfilePicture));

      verify(() => mockNavigationService.pushNamed(Routes.IMAGESOURCE,
          arguments: any(named: 'arguments')));
    });
  });
}
