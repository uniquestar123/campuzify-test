import 'dart:convert';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/account/account.dart';

class AccountLocalStorage {
  List<Account> getAccountLocal() {
    try {
      List<String>? cached = preferences.getStringList(PreferencesName.accountLocal);
      cached ??= [];

      return cached.map((json) => Account.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      throw Exception();
    }
  }

  void saveAccountLocal(Account account) {
    String json = jsonEncode(account.toJson());

    List<String>? cached = preferences.getStringList(PreferencesName.accountLocal);

    cached ??= [];

    cached = [];
    cached.add(json);

    preferences.setStringList(PreferencesName.accountLocal, cached);
  }
}
