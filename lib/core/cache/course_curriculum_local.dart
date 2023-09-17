import 'dart:convert';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';

class CurriculumLocalStorage {
  List<CurriculumResponse> getCurriculumLocal(int id) {
    try {
      List<String>? cached = preferences.getStringList(PreferencesName.courseCurriculum);
      cached ??= [];

      return cached.map((json) => CurriculumResponse.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      throw Exception();
    }
  }

  void saveCurriculum(CurriculumResponse curriculumResponse, int id) {
    String json = jsonEncode(curriculumResponse.toJson());

    List<String>? cached = preferences.getStringList(PreferencesName.courseCurriculum);

    cached ??= [];

    cached = [];
    cached.add(json);

    preferences.setStringList(PreferencesName.courseCurriculum, cached);
  }
}
