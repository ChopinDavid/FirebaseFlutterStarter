part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginUserWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;

  LoginUserWithEmailAndPassword({required this.email, required this.password});
}

class SignupUserWithEmailAndPassword extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  SignupUserWithEmailAndPassword({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class ResetAuthState extends AuthEvent {}

class SignOut extends AuthEvent {
  final NavigationService navigationService;

  SignOut({required this.navigationService});
}
