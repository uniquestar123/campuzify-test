part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

class SendChangePasswordEvent extends ChangePasswordEvent {
  SendChangePasswordEvent(this.oldPassword, this.newPassword);

  final oldPassword;
  final newPassword;
}
