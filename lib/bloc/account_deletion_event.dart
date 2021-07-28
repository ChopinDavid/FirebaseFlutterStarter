part of 'account_deletion_bloc.dart';

@immutable
abstract class AccountDeletionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeleteAccount extends AccountDeletionEvent {
  final String? enteredPassword;
  DeleteAccount({required this.enteredPassword});

  @override
  List<Object?> get props => [
        enteredPassword,
      ];
}
