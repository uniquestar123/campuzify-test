part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordState {}

class InitialChangePasswordState extends ChangePasswordState {}

class LoadingChangePasswordState extends ChangePasswordState {}

class SuccessChangePasswordState extends ChangePasswordState {}

class ErrorChangePasswordState extends ChangePasswordState {
  ErrorChangePasswordState(this.message);

  final String? message;
}
