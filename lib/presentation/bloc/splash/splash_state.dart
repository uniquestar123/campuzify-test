part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class InitialSplashState extends SplashState {}

class LoadingSplashState extends SplashState {}

class CloseSplashState extends SplashState {
  CloseSplashState(this.appSettings);

  final AppSettings? appSettings;
}

class ErrorSplashState extends SplashState {
  ErrorSplashState(this.message);

  final String? message;
}
