part of 'account_deletion_bloc.dart';

@immutable
abstract class AccountDeletionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeleteAccount extends AccountDeletionEvent {
  final String? enteredPassword;
  final NavigationService navigationService;
  DeleteAccount(
      {required this.enteredPassword, required this.navigationService});

  @override
  List<Object?> get props => [
        enteredPassword,
        navigationService,
      ];
}
