part of 'restore_password_bloc.dart';

@immutable
abstract class RestorePasswordEvent {}

class SendRestorePasswordEvent extends RestorePasswordEvent {
  SendRestorePasswordEvent(this.email);

  final String email;
}
