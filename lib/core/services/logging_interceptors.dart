import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:masterstudy_app/core/cache/cache_manager.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/screens/splash/splash_screen.dart';

class LoggingInterceptor extends Interceptor {
  static const encoder = JsonEncoder.withIndent('\t');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers.containsKey('requirestoken')) {
      options.headers.remove('requirestoken');

      String? apiToken = preferences.getString(PreferencesName.apiToken);

      if (apiToken != null && apiToken.isNotEmpty) {
        options.headers.addAll({'token': apiToken});
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data.runtimeType == ResponseBody) {
      logger.i('''RESPONSE: ''');
    } else {
      logger.i('''RESPONSE:
      URL: ${response.requestOptions.uri}
      Method: ${response.requestOptions.method}
      Headers: ${encoder.convert(response.requestOptions.headers)}
      Data: ${encoder.convert(response.data)}
      ''');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null && err.response?.statusCode != null && err.response?.statusCode == 401) {
      (CacheManager()).cleanCache();
      preferences.remove(PreferencesName.apiToken);

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        SplashScreen.routeName,
        (Route<dynamic> route) => false,
      );
    }
    return handler.next(err);
  }
}
