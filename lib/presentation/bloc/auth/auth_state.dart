part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class InitialAuthState extends AuthState {}

// SignInState
class LoadingSignInState extends AuthState {}

class SuccessSignInState extends AuthState {}

class ErrorSignInState extends AuthState {
  ErrorSignInState(this.message);

  final String message;
}

// SignUpState
class LoadingSignUpState extends AuthState {}

class SuccessSignUpState extends AuthState {}

class ErrorSignUpState extends AuthState {
  ErrorSignUpState(this.message);

  final String message;
}

// DemoState
class LoadingDemoAuthState extends AuthState {}

class SuccessDemoAuthState extends AuthState {}

class ErrorDemoAuthState extends AuthState {
  ErrorDemoAuthState(this.message);

  final String message;
}

// AuthSocials
class LoadingAuthGoogleState extends AuthState {}

class LoadingAuthFacebookState extends AuthState {}

class SuccessAuthSocialsState extends AuthState {
  SuccessAuthSocialsState(this.photoUrl);

  final File? photoUrl;
}

class ErrorAuthSocialsState extends AuthState {
  ErrorAuthSocialsState(this.message);

  final String message;
}
