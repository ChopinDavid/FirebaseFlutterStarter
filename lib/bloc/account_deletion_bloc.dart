import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_starter/services/document_service.dart';
import 'package:firebase_flutter_starter/services/firestore_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../services/navigation_service.dart';

part 'account_deletion_event.dart';
part 'account_deletion_state.dart';

final FirebaseAuth _auth = GetIt.instance.get<FirebaseAuth>();

class AccountDeletionBloc
    extends Bloc<AccountDeletionEvent, AccountDeletionState> {
  AccountDeletionBloc() : super(AccountDeletionInitial());

  @override
  Stream<AccountDeletionState> mapEventToState(
    AccountDeletionEvent event,
  ) async* {
    if (event is DeleteAccount) {
      yield AccountDeletionLoading();
      try {
        final User? _user = _auth.currentUser;
        if (_user == null) {
          throw Exception('User does not exist');
        } else {
          if (event.enteredPassword != null) {
            final AuthCredential credential = EmailAuthProvider.credential(
                email: _user.email!, password: event.enteredPassword!);
            await _auth.currentUser!.reauthenticateWithCredential(credential);
          }
          await GetIt.instance
              .get<FirestoreService>()
              .deleteUser(uid: _user.uid);
          await _auth.currentUser!.delete();
          imageCache!.clear();
          imageCache!.clearLiveImages();
          await GetIt.instance
              .get<DocumentService>()
              .deleteFile(relativePath: 'profilePicture');
          event.navigationService.popToRoot();
        }
      } on FirebaseAuthException catch (error) {
        if (error.code == 'wrong-password') {
          yield AccountDeletionWrongPassword(error: error);
        } else if (error.code == 'requires-recent-login') {
          yield AccountDeletionNeedsToReauthenticate(error: error);
        }
      }
    }
  }
}
