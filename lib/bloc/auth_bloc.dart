import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_starter/services/firestore_service.dart';
import 'package:firebase_flutter_starter/services/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginUserWithEmailAndPassword) {
      yield AuthLoading();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: event.email, password: event.password);
        yield (AuthLoginComplete(userCredential: userCredential));
      } on FirebaseAuthException catch (e) {
        yield (AuthSignupError(error: e));
      }
    } else if (event is SignupUserWithEmailAndPassword) {
      yield AuthLoading();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: event.email, password: event.password);
        await GetIt.instance.get<FirestoreService>().createUser(
              userId: userCredential.user!.uid,
              firstName: event.firstName,
              lastName: event.lastName,
              email: event.email,
            );
        yield (AuthSignupComplete(userCredential: userCredential));
      } on FirebaseAuthException catch (e) {
        yield (AuthSignupError(error: e));
      }
    } else if (event is ResetAuthState) {
      yield AuthInitial();
    } else if (event is SignOut) {
      await FirebaseAuth.instance.signOut();
      event.navigationService.popToRoot();
    }
  }
}
