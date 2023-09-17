import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/errors/auth_error.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/auth/auth.dart';
import 'package:masterstudy_app/data/models/auth_error/auth_error.dart';
import 'package:masterstudy_app/data/models/change_password/change_password.dart';
import 'package:masterstudy_app/data/models/restore_password/restore_password.dart';

abstract class AuthDataSource {
  Future<AuthResponse> signIn(String login, String password);

  Future<AuthResponse> signUp(String login, String email, String password);

  Future<RestorePasswordResponse> restorePassword(String email);

  Future<ChangePasswordResponse> changePassword(String oldPassword, String newPassword);

  Future authSocialsUser(String providerType, String? idToken, String accessToken);

  Future<String> demoAuth();
}

class AuthDataSourceImpl implements AuthDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<AuthResponse> signIn(String login, String password) async {
    try {
      Response response = await _httpService.dio.post(
        '/login',
        data: {
          'login': login,
          'password': password,
        },
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthError(AuthErrorResponse.fromJson(e.response!.data));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AuthResponse> signUp(String login, String email, String password) async {
    try {
      Response response = await _httpService.dio.post(
        '/registration',
        data: {
          'login': login,
          'email': email,
          'password': password,
        },
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthError(AuthErrorResponse.fromJson(e.response!.data));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<RestorePasswordResponse> restorePassword(String email) async {
    try {
      Response response = await _httpService.dio.post(
        '/account/restore_password',
        data: {'email': email},
      );
      return RestorePasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthError(AuthErrorResponse.fromJson(e.response!.data));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future authSocialsUser(String providerType, String? idToken, String accessToken) async {
    var params = {
      'provider': providerType,
      'id_token': idToken,
      'access_token': accessToken,
    };

    try {
      Response response = await _httpService.dio.post(
        '/login/socials',
        queryParameters: params,
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<String> demoAuth() async {
    try {
      Response response = await _httpService.dio.get('/demo');

      return response.data['token'];
    } on DioException catch (e) {
      throw AuthError(AuthErrorResponse.fromJson(e.response!.data));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ChangePasswordResponse> changePassword(String oldPassword, String newPassword) async {
    try {
      Response response = await _httpService.dio.post(
        '/account/edit_profile',
        queryParameters: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return ChangePasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
