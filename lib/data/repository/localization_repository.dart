import 'dart:convert';

import 'package:flutter/services.dart';

class LocalizationRepository {
  Map<String, dynamic> localization = {};
  Map<String, dynamic> customLocalization = {};

  String getLocalization(String key) {
    if (localization.containsKey(key)) {
      return localization[key];
    }

    if (customLocalization.containsKey(key)) {
      return customLocalization[key];
    }

    return 'Unknown Letter';
  }

  void saveCustomLocalization(Map<String, dynamic> customLocalization) async {
    Map<String, dynamic> jsonString = customLocalization;

    final customJsonString = await rootBundle.loadString('assets/localization/default_locale.json');

    Map<String, dynamic> jsonMap = jsonDecode(customJsonString);

    this.customLocalization = jsonMap.map((key, value) => MapEntry(key, value.toString()));

    localization = jsonString.map((key, value) => MapEntry(key, value.toString()));
  }
}
