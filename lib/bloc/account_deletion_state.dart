part of 'account_deletion_bloc.dart';

@immutable
abstract class AccountDeletionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountDeletionInitial extends AccountDeletionState {}

class AccountDeletionLoading extends AccountDeletionState {}

class AccountDeletionError extends AccountDeletionState {
  final Exception error;
  AccountDeletionError({required this.error});

  @override
  List<Object?> get props => [
        error,
      ];
}

class AccountDeletionNeedsToReauthenticate extends AccountDeletionError {
  AccountDeletionNeedsToReauthenticate({required Exception error})
      : super(error: error);
}

class AccountDeletionWrongPassword extends AccountDeletionError {
  AccountDeletionWrongPassword({required Exception error})
      : super(error: error);
}

class AccountDeletionSuccess extends AccountDeletionState {}
