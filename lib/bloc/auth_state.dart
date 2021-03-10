part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginComplete extends AuthState {
  final UserCredential userCredential;

  AuthLoginComplete({required this.userCredential});
}

class AuthSignupComplete extends AuthState {
  final UserCredential userCredential;

  AuthSignupComplete({required this.userCredential});
}

class AuthSignupError extends AuthState {
  final Exception error;
  AuthSignupError({required this.error});
}
