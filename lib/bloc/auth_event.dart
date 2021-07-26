part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginUserWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;

  LoginUserWithEmailAndPassword({required this.email, required this.password});

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}

class SignupUserWithEmailAndPassword extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final File? profilePicture;

  SignupUserWithEmailAndPassword({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        password,
        profilePicture,
      ];
}

class ResetAuthState extends AuthEvent {}

class SignOut extends AuthEvent {
  final NavigationService navigationService;

  SignOut({required this.navigationService});

  @override
  List<Object?> get props => [
        navigationService,
      ];
}
