import 'package:masterstudy_app/core/cache/app_settings_local.dart';
import 'package:masterstudy_app/core/cache/localization_local.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/datasources/home_datasource.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/category/category.dart';

abstract class HomeRepository {
  Future<AppSettings> getAppSettings();

  Future<List<Category>> getCategories();

  Future<Map<String, dynamic>> getLocalization();

  Future saveLocal(AppSettings appSettings);

  Future<List<AppSettings>> getAppSettingsLocal();

  Future<Map<String, dynamic>> getAllLocalizationLocal();

  void saveLocalizationLocal(Map<String, dynamic> localizationMap);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _homeDataSource = HomeRemoteDataSource();
  final AppLocalStorage _appLocalStorage = AppLocalStorage();
  final LocalizationLocalStorage _localizationLocalStorage = LocalizationLocalStorage();

  @override
  Future<AppSettings> getAppSettings() async => await _homeDataSource.getAppSettings();

  @override
  Future<List<Category>> getCategories() async => await _homeDataSource.getCategories();

  @override
  Future saveLocal(AppSettings appSettings) async {
    try {
      return _appLocalStorage.saveLocalAppSetting(appSettings);
    } catch (e, s) {
      logger.e('Error saveLocalAppSettings', e, s);
    }
  }

  @override
  Future<List<AppSettings>> getAppSettingsLocal() async {
    return _appLocalStorage.getAppSettingsLocal();
  }

  @override
  void saveLocalizationLocal(Map<String, dynamic> localizationMap) {
    try {
      return _localizationLocalStorage.saveLocalizationLocal(localizationMap);
    } catch (e, s) {
      logger.e('Error with saveLocalization', e, s);
    }
  }

  @override
  Future<Map<String, dynamic>> getAllLocalizationLocal() async {
    return _localizationLocalStorage.getLocalization();
  }

  @override
  Future<Map<String, dynamic>> getLocalization() async => await _homeDataSource.getLocalization();
}
