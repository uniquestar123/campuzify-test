part of 'detail_profile_bloc.dart';

@immutable
abstract class DetailProfileEvent {}

class FetchDetailProfile extends DetailProfileEvent {
  FetchDetailProfile(this.id);

  final int? id;
}

