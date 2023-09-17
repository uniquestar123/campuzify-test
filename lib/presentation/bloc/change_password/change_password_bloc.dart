import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/change_password/change_password.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(InitialChangePasswordState()) {
    on<SendChangePasswordEvent>((event, emit) async {
      emit(LoadingChangePasswordState());
      try {
        ChangePasswordResponse response = await _authRepository.changePassword(
          event.oldPassword,
          event.newPassword,
        );

        if (!response.modified.newPassword) {
          emit(
            ErrorChangePasswordState(response.values['old_password']),
          );
        } else {
          emit(SuccessChangePasswordState());
        }
      } catch (e, s) {
        logger.e('Error changePassword', e, s);
        emit(ErrorChangePasswordState('Unknown Error'));
      }
    });
  }

  final AuthRepository _authRepository = AuthRepositoryImpl();
}
