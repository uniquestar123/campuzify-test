part of 'restore_password_bloc.dart';

@immutable
abstract class RestorePasswordState {}

class InitialRestorePasswordState extends RestorePasswordState {}

class LoadingRestorePasswordState extends RestorePasswordState {}

class SuccessRestorePasswordState extends RestorePasswordState {}

class ErrorRestorePasswordState extends RestorePasswordState {
  ErrorRestorePasswordState(this.message);

  final String message;
}
