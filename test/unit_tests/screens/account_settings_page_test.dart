import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_starter/bloc/account_deletion_bloc.dart';
import 'package:firebase_flutter_starter/screens/account_settings_page.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import '../../test_utils.dart';

void main() {
  late AccountDeletionBloc mockAccountDeletionBloc;
  late NavigationService mockNavigationService;

  setUpAll(() async {
    TestUtils.setupCloudFirestoreMocks();
    await Firebase.initializeApp();
    TestUtils.registerFallbacks();
  });

  setUp(() async {
    await GetIt.instance.reset();
    mockAccountDeletionBloc = MockAccountDeletionBloc();
    mockNavigationService = MockNavigationService();

    GetIt.instance.registerSingleton<NavigationService>(mockNavigationService);
  });

  group('Account deletion', () {
    testWidgets(
        'When the user taps the "Delete Account" button, then the account deletion verification dialog should appear',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AccountSettingsPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('initial-delete-account-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('account-deletion-verification-dialog')),
          findsOneWidget);
    });

    testWidgets(
        'When the user taps the final "Delete Account" button and the user\'s password does not need to be re-entered, then the user should be popped back to the welcome page',
        (WidgetTester tester) async {
      whenListen(mockAccountDeletionBloc,
          Stream.fromIterable([AccountDeletionSuccess()]),
          initialState: AccountDeletionInitial());

      await tester.pumpWidget(MaterialApp(
          home: AccountSettingsPage(
        injectedAccountDeletionBloc: mockAccountDeletionBloc,
      )));
      await tester.tap(find.byKey(Key('initial-delete-account-button')));
      await tester.pump();
      await tester.tap(find.byKey(Key('final-delete-account-button')));

      verify(() => mockNavigationService.popToRoot());
    });

    testWidgets(
        'When the user taps the final "Delete Account" button and the user\'s password does need to be re-entered, then the user should be prompted to enter their password',
        (WidgetTester tester) async {
      whenListen(
          mockAccountDeletionBloc,
          Stream.fromIterable([
            AccountDeletionNeedsToReauthenticate(
                error: Exception('you need to re-enter your password'))
          ]),
          initialState: AccountDeletionInitial());

      await tester.pumpWidget(MaterialApp(
          home: AccountSettingsPage(
        injectedAccountDeletionBloc: mockAccountDeletionBloc,
      )));
      await tester.tap(find.byKey(Key('initial-delete-account-button')));
      await tester.pump();
      await tester.tap(find.byKey(Key('final-delete-account-button')));
      await tester.pump();

      expect(find.byKey(Key('enter-password-modal')), findsOneWidget);
      expect(find.byKey(Key('wrong-password-text')), findsNothing);
    });

    testWidgets(
        'When the user taps the final "Delete Account" button, the user\'s password does need to be re-entered, and the user enters the wrong password, then the user should be informed that they entered an incorrect password',
        (WidgetTester tester) async {
      whenListen(
          mockAccountDeletionBloc,
          Stream.fromIterable([
            AccountDeletionWrongPassword(
                error: Exception('you entered the wrong password'))
          ]),
          initialState: AccountDeletionInitial());

      await tester.pumpWidget(MaterialApp(
          home: AccountSettingsPage(
        injectedAccountDeletionBloc: mockAccountDeletionBloc,
      )));
      await tester.tap(find.byKey(Key('initial-delete-account-button')));
      await tester.pump();
      await tester.tap(find.byKey(Key('final-delete-account-button')));
      await tester.pump();

      expect(find.byKey(Key('enter-password-modal')), findsOneWidget);
      expect(find.byKey(Key('wrong-password-text')), findsOneWidget);
    });
  });
}
