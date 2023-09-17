import 'dart:convert';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';

class AppLocalStorage {
  List<AppSettings> getAppSettingsLocal() {
    try {
      List<String>? cached = preferences.getStringList(PreferencesName.localAppSettings);
      cached ??= [];

      return cached.map((json) => AppSettings.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      throw Exception();
    }
  }

  void saveLocalAppSetting(AppSettings appSettings) {
    String json = jsonEncode(appSettings.toJson());

    List<String>? cachedApp = preferences.getStringList(PreferencesName.localAppSettings);

    cachedApp ??= [];

    cachedApp = [];
    cachedApp.add(json);

    preferences.setStringList(PreferencesName.localAppSettings, cachedApp);
  }
}
