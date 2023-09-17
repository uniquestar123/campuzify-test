import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/errors/auth_error.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState()) {
    on<SignUpEvent>((event, emit) async {
      emit(LoadingSignUpState());
      try {
        await _repository.signUp(
          event.login,
          event.email,
          event.password,
        );
        emit(SuccessSignUpState());
      } on AuthError catch (e, s) {
        logger.e('Error signUp from API', e, s);
        emit(ErrorSignUpState(e.authErrorResponse.message ?? 'Unknown Error'));
      } catch (e, s) {
        logger.e('Error signUp', e, s);
        emit(ErrorSignInState(e.toString()));
      }
    });

    on<SignInEvent>((event, emit) async {
      emit(LoadingSignInState());
      try {
        await _repository.signIn(event.login, event.password);
        emit(SuccessSignInState());
      } on AuthError catch (e, s) {
        logger.e('Error signIn from API', e, s);
        emit(ErrorSignInState(e.authErrorResponse.message ?? 'Unknown Error'));
      } catch (e, s) {
        logger.e('Error signIn', e, s);
        emit(ErrorSignInState(e.toString()));
      }
    });

    on<DemoAuthEvent>((event, emit) async {
      emit(LoadingDemoAuthState());
      try {
        preferences.setBool(PreferencesName.demoMode, true);
        await _repository.demoAuth();
        emit(SuccessDemoAuthState());
      } on AuthError catch (e, s) {
        logger.e('Error calling demoAuth()', e, s);
        preferences.remove(PreferencesName.demoMode);
        emit(ErrorDemoAuthState(e.authErrorResponse.message ?? 'Unknown Error'));
      } catch (e, s) {
        logger.e('Error demoAuth', e, s);
        preferences.remove(PreferencesName.demoMode);
        var errorData = json.decode(e.toString());
        emit(ErrorDemoAuthState(errorData['message']));
      }
    });

    on<AuthSocialsEvent>((event, emit) async {
      if (event.providerType == 'google') {
        emit(LoadingAuthGoogleState());
      } else {
        emit(LoadingAuthFacebookState());
      }

      try {
        await _repository.authSocialsUser(
          event.providerType,
          event.idToken ?? '',
          event.accessToken,
        );

        emit(SuccessAuthSocialsState(event.photoUrl));
      } catch (e, s) {
        logger.e('Error authSocialsUser', e, s);
        emit(ErrorAuthSocialsState(e.toString()));
      }
    });

    on<CloseDialogEvent>((event, emit) {
      emit(InitialAuthState());
    });
  }

  final AuthRepository _repository = AuthRepositoryImpl();
}
