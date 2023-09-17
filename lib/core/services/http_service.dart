import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:masterstudy_app/core/constants/app_config.dart';
import 'package:masterstudy_app/core/services/logging_interceptors.dart';

class HttpService {
  HttpService() {
    baseUrl = baseUrl;
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.interceptors.add(LoggingInterceptor());
  }

  static String baseUrl = AppConfig.endPoint;
  late Dio dio;
}
