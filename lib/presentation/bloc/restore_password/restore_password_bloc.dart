import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/errors/auth_error.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/restore_password/restore_password.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'restore_password_event.dart';

part 'restore_password_state.dart';

class RestorePasswordBloc extends Bloc<RestorePasswordEvent, RestorePasswordState> {
  RestorePasswordBloc() : super(InitialRestorePasswordState()) {
    on<SendRestorePasswordEvent>((event, emit) async {
      emit(LoadingRestorePasswordState());
      try {
        RestorePasswordResponse restorePasswordResponse = await _authRepository.restorePassword(event.email);

        if (restorePasswordResponse.status.toString() == 'error') {
          emit(ErrorRestorePasswordState(restorePasswordResponse.message));
          return;
        } else {
          emit(SuccessRestorePasswordState());
        }
      } on AuthError catch (e, s) {
        logger.e('Error restorePassword from API', e, s);
        emit(ErrorRestorePasswordState(e.authErrorResponse.message ?? 'Unknown Error'));
      } catch (e, s) {
        logger.e('Error restorePassword', e, s);
        emit(ErrorRestorePasswordState('Error with API'));
      }
    });
  }

  final AuthRepository _authRepository = AuthRepositoryImpl();
}
