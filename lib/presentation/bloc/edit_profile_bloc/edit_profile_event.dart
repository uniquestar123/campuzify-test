part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class UploadPhotoProfileEvent extends EditProfileEvent {
  UploadPhotoProfileEvent(this.photo);

  final File? photo;
}

class SaveEvent extends EditProfileEvent {
  SaveEvent({
    this.firstName,
    this.lastName,
    this.password,
    this.description,
    this.position,
    this.facebook,
    this.twitter,
    this.instagram,
    this.photo,
    this.onlyPhoto = false,
  });

  final String? firstName;
  final String? lastName;
  final String? password;
  final String? description;
  final String? position;
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final File? photo;
  final bool onlyPhoto;
}

class DeleteAccountEvent extends EditProfileEvent {
  DeleteAccountEvent({this.accountId});

  final int? accountId;
}

class CloseScreenEvent extends EditProfileEvent {}
