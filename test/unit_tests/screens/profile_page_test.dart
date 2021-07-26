import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_starter/bloc/auth_bloc.dart';
import 'package:firebase_flutter_starter/models/routes.dart';
import 'package:firebase_flutter_starter/screens/profile_page.dart';
import 'package:firebase_flutter_starter/services/document_service.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/services/shared_preferences_service.dart';
import 'package:firebase_flutter_starter/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import '../../test_data.dart' as testData;
import '../../test_utils.dart';

void main() {
  late AuthBloc mockAuthBloc;
  late File mockProfilePicture;
  late NavigationService mockNavigationService;
  late SharedPreferencesService mockSharedPreferencesService;
  late DocumentService mockDocumentService;

  setUpAll(() async {
    TestUtils.setupCloudFirestoreMocks();
    await Firebase.initializeApp();
    TestUtils.registerFallbacks();
  });

  setUp(() async {
    await GetIt.instance.reset();
    mockAuthBloc = MockAuthBloc();
    mockProfilePicture = MockFile();
    mockNavigationService = MockNavigationService();
    mockSharedPreferencesService = MockSharedPreferencesService();
    mockDocumentService = MockDocumentService();

    when(() => mockProfilePicture.exists())
        .thenAnswer((invocation) async => false);
    when(() => mockSharedPreferencesService.getCurrentUser()).thenAnswer(
        (invocation) async => testData.firebaseFlutterStarterUser());
    when(() => mockDocumentService.getImage(
            relativePath: any(named: 'relativePath')))
        .thenAnswer((invocation) async => mockProfilePicture);

    GetIt.instance.registerSingleton<NavigationService>(mockNavigationService);
    GetIt.instance.registerSingleton<SharedPreferencesService>(
        mockSharedPreferencesService);
    GetIt.instance.registerSingleton<DocumentService>(mockDocumentService);
  });

  group('profile picture', () {
    testWidgets('Tapping profile picture brings up ImageSourceOverlay',
        (WidgetTester tester) async {
      whenListen(
          mockAuthBloc,
          Stream.fromIterable(
              [AuthLoginComplete(userCredential: MockUserCredential())]),
          initialState: AuthInitial());

      await tester.pumpWidget(MaterialApp(
          home: BlocProvider<AuthBloc>(
              create: (context) => mockAuthBloc,
              child: ProfilePage(
                onProfilePictureUpdated: () {},
              ))));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ProfilePicture));

      verify(() => mockNavigationService.pushNamed(Routes.IMAGESOURCE,
          arguments: any(named: 'arguments')));
    });
  });

  group('buttons', () {
    testWidgets('Tapping "Account Settings" pushes the AccountSettingsPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (context) => mockAuthBloc,
            child: ProfilePage(
              onProfilePictureUpdated: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(Key('account-settings-button')));

      verify(() => mockNavigationService.pushNamed(Routes.ACCOUNTSETTINGS));
    });

    testWidgets('Tapping "Logout" logs the user out',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (context) => mockAuthBloc,
            child: ProfilePage(
              onProfilePictureUpdated: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(Key('logout-button')));

      verify(() =>
          mockAuthBloc.add(SignOut(navigationService: mockNavigationService)));
    });
  });
}
