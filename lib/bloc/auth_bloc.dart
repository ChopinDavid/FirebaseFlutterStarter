import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_starter/models/firebase_flutter_starter_user.dart';
import 'package:firebase_flutter_starter/services/document_service.dart';
import 'package:firebase_flutter_starter/services/firestore_service.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:firebase_flutter_starter/services/shared_preferences_service.dart';
import 'package:flutter/painting.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final FirebaseAuth _auth = GetIt.instance.get<FirebaseAuth>();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginUserWithEmailAndPassword) {
      yield AuthLoading();
      try {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
                email: event.email, password: event.password);
        if (userCredential.user != null) {
          final FirebaseFlutterStarterUser? user = await GetIt.instance
              .get<FirestoreService>()
              .getUser(uid: userCredential.user!.uid);
          if (user != null) {
            await GetIt.instance
                .get<SharedPreferencesService>()
                .storeCurrentUser(user: user);
            if (user.profilePictureUrl != null) {
              final http.Response response =
                  await http.get(Uri.parse(user.profilePictureUrl!));
              await GetIt.instance.get<DocumentService>().saveImageFromBytes(
                  bytes: response.bodyBytes, relativePath: 'profilePicture');
            }
            yield (AuthLoginComplete(userCredential: userCredential));
            return;
          }
        }
        yield (AuthSignupError(
            error: Exception('An unknown error occurred...')));
      } on FirebaseAuthException catch (e) {
        yield (AuthSignupError(error: e));
      }
    } else if (event is SignupUserWithEmailAndPassword) {
      yield AuthLoading();
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: event.email, password: event.password);
        await GetIt.instance.get<FirestoreService>().createUser(
              uid: userCredential.user!.uid,
              firstName: event.firstName,
              lastName: event.lastName,
              email: event.email,
              profilePicture: event.profilePicture,
            );
        yield (AuthSignupComplete(userCredential: userCredential));
      } on FirebaseAuthException catch (e) {
        yield (AuthSignupError(error: e));
      }
    } else if (event is ResetAuthState) {
      yield AuthInitial();
    } else if (event is SignOut) {
      await _auth.signOut();
      imageCache!.clear();
      imageCache!.clearLiveImages();
      await GetIt.instance
          .get<DocumentService>()
          .deleteFile(relativePath: 'profilePicture');
      event.navigationService.popToRoot();
    }
  }
}
