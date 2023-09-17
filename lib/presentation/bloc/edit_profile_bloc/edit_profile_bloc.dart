import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/account/account.dart';
import 'package:masterstudy_app/data/repository/account_repository.dart';
import 'package:meta/meta.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(InitialEditProfileState()) {
    on<SaveEvent>((event, emit) async {
      emit(LoadingEditProfileState());
      try {
        await _repository.editProfile(
          firstName: event.firstName,
          lastName: event.lastName,
          password: event.password,
          description: event.description,
          position: event.position,
          facebook: event.facebook,
          twitter: event.twitter,
          instagram: event.instagram,
        );

        try {
          if (event.photo != null) {
            await _repository.uploadProfilePhoto(event.photo!);
          }
        } catch (e) {
          emit(ErrorEditProfileState());
        }

        emit(UpdatedEditProfileState());
      } catch (e, s) {
        logger.e('Error with method editProfile()', e, s);
        emit(ErrorEditProfileState());
      }
    });

    on<UploadPhotoProfileEvent>((event, emit) async {
      try {
        await _repository.uploadProfilePhoto(event.photo!);
      } catch (e, s) {
        logger.e('Error with method uploadProfilePhoto()', e, s);
        emit(ErrorEditProfileState());
      }
    });

    on<CloseScreenEvent>((event, emit) {
      emit(CloseEditProfileState());
    });

    on<DeleteAccountEvent>((event, emit) async {
      emit(LoadingDeleteAccountState());

      try {
        final response = await _repository.deleteAccount(accountId: event.accountId!);

        if (response['success'] == false) {
          emit(ErrorDeleteAccountState());
        } else {
          emit(SuccessDeleteAccountState());
        }
      } catch (e, s) {
        logger.e('Error deleteAccount', e, s);
        emit(ErrorDeleteAccountState());
      }
    });
  }

  final AccountRepository _repository = AccountRepositoryImpl();
  late Account account;
}
