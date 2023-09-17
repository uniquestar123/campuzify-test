part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

class LoadedProfileState extends ProfileState {
  LoadedProfileState(this.account);

  final Account account;
}

class LogoutProfileState extends ProfileState {}

class UnauthorizedState extends ProfileState {}
