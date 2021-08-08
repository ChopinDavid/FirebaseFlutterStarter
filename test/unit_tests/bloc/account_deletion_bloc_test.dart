import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart'
    as FirebaseAuthMocks;
import 'package:firebase_flutter_starter/bloc/account_deletion_bloc.dart';
import 'package:firebase_flutter_starter/services/document_service.dart';
import 'package:firebase_flutter_starter/services/firestore_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import '../../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AccountDeletionBloc testObject;
  late FirebaseAuth mockFirebaseAuth;
  late User mockFirebaseAuthUser;
  late FirestoreService mockFirestoreService;
  late DocumentService mockDocumentService;

  setUpAll(() {
    TestUtils.registerFallbacks();
    testObject = AccountDeletionBloc();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseAuthUser = FirebaseAuthMocks.MockUser(email: 'leo@tolstoy.com');
    mockFirestoreService = MockFirestoreService();
    mockDocumentService = MockDocumentService();
    when(() => mockFirebaseAuth.currentUser).thenReturn(mockFirebaseAuthUser);
    when(() => mockFirestoreService.deleteUser(uid: any(named: 'uid')))
        .thenAnswer((invocation) async => {});
    when(() => mockDocumentService.deleteFile(
            relativePath: any(named: 'relativePath')))
        .thenAnswer((invocation) async => null);
    GetIt.instance.registerSingleton<FirebaseAuth>(mockFirebaseAuth);
    GetIt.instance.registerSingleton<FirestoreService>(mockFirestoreService);
    GetIt.instance.registerSingleton<DocumentService>(mockDocumentService);
  });

  blocTest<AccountDeletionBloc, AccountDeletionState>(
    'should emit AgendaItemRatingLoading then AgendaItemRatingLoaded on LoadAgendaItemRating',
    build: () => testObject,
    act: (bloc) async => bloc.add(DeleteAccount(enteredPassword: 'Novels9@')),
    expect: () => [
      AccountDeletionLoading(),
      AccountDeletionSuccess(),
    ],
  );

  test('', () {
    when(mockFirebaseAuthUser.delete)
        .thenThrow(FirebaseAuthException(code: '1'));
    blocTest<AccountDeletionBloc, AccountDeletionState>(
      'should emit AgendaItemRatingLoading then AgendaItemRatingLoaded on LoadAgendaItemRating',
      build: () => testObject,
      act: (bloc) async => bloc.add(DeleteAccount(enteredPassword: 'Novels9@')),
      expect: () => [
        AccountDeletionLoading(),
        AccountDeletionWrongPassword(error: Exception()),
      ],
    );
  });
}
