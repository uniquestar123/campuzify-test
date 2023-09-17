part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  SignInEvent(this.login, this.password);

  final String login;
  final String password;
}

class SignUpEvent extends AuthEvent {
  SignUpEvent(this.login, this.email, this.password);

  final String login;
  final String email;
  final String password;
}

class AuthSocialsEvent extends AuthEvent {
  AuthSocialsEvent({
    required this.providerType,
    this.idToken,
    required this.accessToken,
    this.photoUrl,
  });

  final String providerType;
  final String? idToken;
  final String accessToken;
  final File? photoUrl;
}

class CloseDialogEvent extends AuthEvent {}

class DemoAuthEvent extends AuthEvent {}
