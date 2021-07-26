import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/screens/login_page.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import '../../test_utils.dart';

void main() {
  late AuthBloc mockAuthBloc;
  late NavigationService mockNavigationService;

  setUpAll(() async {
    TestUtils.setupCloudFirestoreMocks();
    await Firebase.initializeApp();
    TestUtils.registerFallbacks();
  });

  setUp(() async {
    await GetIt.instance.reset();

    mockAuthBloc = MockAuthBloc();
    mockNavigationService = MockNavigationService();

    GetIt.instance.registerSingleton<NavigationService>(mockNavigationService);
  });

  group('Form validation', () {
    setUp(() {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    });
    group('Email field', () {
      testWidgets(
          'Shows "Please enter an email address..." if the user fails to enter an email address and clicks on the "Login" button.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
            home: BlocProvider<AuthBloc>(
                create: (context) => mockAuthBloc, child: LoginPage())));

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
        await tester.pumpWidget(MaterialApp(
            home: BlocProvider<AuthBloc>(
                create: (context) => mockAuthBloc, child: LoginPage())));

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
        await tester.pumpWidget(MaterialApp(
            home: BlocProvider<AuthBloc>(
                create: (context) => mockAuthBloc, child: LoginPage())));

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
      whenListen(
          mockAuthBloc,
          Stream.fromIterable(
              [AuthLoginComplete(userCredential: MockUserCredential())]),
          initialState: AuthInitial());

      await tester.pumpWidget(MaterialApp(
          home: BlocProvider<AuthBloc>(
              create: (context) => mockAuthBloc, child: LoginPage())));

      await tester.enterText(find.byKey(Key('email-field')), 'leo@tolstoy.com');
      await tester.enterText(find.byKey(Key('password-field')), 'Novels9@');

      final Finder loginButtonFinder = find.byKey(Key('login-button-key'));
      await tester.ensureVisible(loginButtonFinder);
      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle();

      verify(() => mockNavigationService.pushNamed(Routes.TABBAR));
    });

    testWidgets('Unsuccessfully logging in displays error dialog',
        (WidgetTester tester) async {
      whenListen(mockAuthBloc,
          Stream.fromIterable([AuthSignupError(error: Exception())]),
          initialState: AuthInitial());

      await tester.pumpWidget(MaterialApp(
          home: BlocProvider<AuthBloc>(
              create: (context) => mockAuthBloc, child: LoginPage())));

      await tester.tap(find.byKey(Key('login-button-key')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('error-dialog')), findsOneWidget);
    });
  });
}
