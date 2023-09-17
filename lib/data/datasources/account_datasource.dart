import 'dart:io';

import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/account/account.dart';

abstract class AccountDataSource {
  Future<Account> getAccount({int? accountId});

  Future editProfile(
    String? firstName,
    String? lastName,
    String? password,
    String? description,
    String? position,
    String? facebook,
    String? instagram,
    String? twitter,
  );

  Future<Response> uploadProfilePhoto(File file);

  Future deleteAccount({int? accountId});
}

class AccountRemoteDataSource extends AccountDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<Account> getAccount({int? accountId}) async {
    Map<String, dynamic> params = {};

    if (accountId != null) {
      params = {'id': accountId};
    }

    try {
      Response response = await _httpService.dio.get(
        '/account/',
        queryParameters: params,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return Account.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future editProfile(
    String? firstName,
    String? lastName,
    String? password,
    String? description,
    String? position,
    String? facebook,
    String? instagram,
    String? twitter,
  ) async {
    try {
      Map<String, String> data = {
        'first_name': firstName!,
        'last_name': lastName!,
        'position': position ?? '',
        'description': description ?? '',
        'facebook': facebook ?? '',
        'instagram': instagram ?? '',
        'twitter': twitter ?? '',
      };

      if (password!.isNotEmpty) data.addAll({'password': password});

      _httpService.dio.post(
        '/account/edit_profile/',
        data: data,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.message);
    }

    return null;
  }

  @override
  Future<Response> uploadProfilePhoto(File file) async {
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    try {
      Response response = await _httpService.dio.post(
        '/account/edit_profile/',
        data: formData,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return response;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future deleteAccount({int? accountId}) async {
    Map<String, dynamic> queryParams = {};

    if (accountId != null) queryParams = {'id': accountId};

    try {
      Response response = await _httpService.dio.delete(
        '/account/',
        queryParameters: queryParams,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
