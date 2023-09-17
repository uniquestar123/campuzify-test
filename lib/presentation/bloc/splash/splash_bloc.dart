import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/repository/home_repository.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(InitialSplashState()) {
    on<LoadSplashEvent>((event, emit) async {
      emit(LoadingSplashState());

      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

      // Если есть подключение к сети, то вызываем getAppSettings()
      // и сразу загружаем кэш в appSettingsLocal()
      if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
        try {
          // Localizations load
          Map<String, dynamic> locale = await _homeRepository.getLocalization();

          _homeRepository.saveLocalizationLocal(locale);

          localizations.saveCustomLocalization(locale);

          // AppSettings load
          AppSettings appSettings = await _homeRepository.getAppSettings();

          _homeRepository.saveLocal(appSettings);

          if (appSettings.options!.logo != null) {
            preferences.setString(PreferencesName.appLogo, appSettings.options!.logo!);
          } else {
            preferences.remove(PreferencesName.appLogo);
          }

          demoEnabled = appSettings.demo ?? false;
          googleOauth = appSettings.options?.googleOauth ?? false;
          facebookOauth = appSettings.options?.facebookOauth ?? false;

          // Addons about count course
          dripContentEnabled =
              appSettings.addons?.sequentialDripContent != null && appSettings.addons?.sequentialDripContent == 'on';

          // Если [main_color] у нас не null, то вызываем функцию ColorRGB
          // Если [main_color] null, то вызываем функцию ColorHex
          if (appSettings.options?.mainColor != null) {
            ColorApp().setMainColorRGB(appSettings.options!.mainColor!);
          } else if (appSettings.options?.mainColorHex != null) {
            ColorApp().setMainColorHex(appSettings.options!.mainColorHex!);
          }

          // Если [secondary_color] не null, то вызываем функцию ColorRGB
          if (appSettings.options?.secondaryColor != null) {
            ColorApp().setSecondaryColorRGB(appSettings.options!.secondaryColor!);
          } else if (appSettings.options?.secondaryColorHex != null) {
            ColorApp().setSecondaryColorHex(appSettings.options!.secondaryColorHex!);
          }

          emit(CloseSplashState(appSettings));
        } on DioException catch (e, s) {
          logger.e('Error dio splash', e, s);
          emit(ErrorSplashState(e.toString()));
        } catch (e, s) {
          logger.e('Error splash', e, s);
          emit(ErrorSplashState(e.toString()));
        }
      } else {
        var locale = await _homeRepository.getAllLocalizationLocal();

        localizations.saveCustomLocalization(locale);

        List<AppSettings> appSettingLocal = await _homeRepository.getAppSettingsLocal();

        if (appSettingLocal.first.options!.logo != null) {
          preferences.setString(PreferencesName.appLogo, appSettingLocal.first.options!.logo!);
        }

        demoEnabled = appSettingLocal.first.demo ?? false;
        googleOauth = appSettingLocal.first.options?.googleOauth ?? false;
        facebookOauth = appSettingLocal.first.options?.facebookOauth ?? false;

        // Addons about count course
        dripContentEnabled = appSettingLocal.first.addons?.sequentialDripContent != null &&
            appSettingLocal.first.addons?.sequentialDripContent == 'on';

        // Если [main_color] у нас не null, то вызываем функцию ColorRGB
        // Если [main_color] null, то вызываем функцию ColorHex
        if (appSettingLocal.first.options?.mainColor != null) {
          ColorApp().setMainColorRGB(appSettingLocal.first.options!.mainColor!);
        } else if (appSettingLocal.first.options?.mainColorHex != null) {
          ColorApp().setMainColorHex(appSettingLocal.first.options!.mainColorHex!);
        }

        // Если [secondary_color] не null, то вызываем функцию ColorRGB
        if (appSettingLocal.first.options?.secondaryColor != null) {
          ColorApp().setSecondaryColorRGB(appSettingLocal.first.options!.secondaryColor!);
        }

        emit(CloseSplashState(appSettingLocal.first));
      }
    });
  }

  final HomeRepository _homeRepository = HomeRepositoryImpl();
}
