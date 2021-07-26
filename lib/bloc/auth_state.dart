part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginComplete extends AuthState {
  final UserCredential userCredential;

  AuthLoginComplete({required this.userCredential});

  @override
  List<Object?> get props => [
        userCredential,
      ];
}

class AuthSignupComplete extends AuthState {
  final UserCredential userCredential;

  AuthSignupComplete({required this.userCredential});

  @override
  List<Object?> get props => [
        userCredential,
      ];
}

class AuthSignupError extends AuthState {
  final Exception error;
  AuthSignupError({required this.error});

  @override
  List<Object?> get props => [
        error,
      ];
}
