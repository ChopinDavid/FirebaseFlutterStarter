part of 'account_deletion_bloc.dart';

@immutable
abstract class AccountDeletionEvent {}

class DeleteAccount extends AccountDeletionEvent {
  final String? enteredPassword;
  final NavigationService navigationService;
  DeleteAccount(
      {required this.enteredPassword, required this.navigationService});
}
