import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/data/models/popular_searches/popular_searches_response.dart';

abstract class CoursesDataSource {
  Future<CoursesResponse> getCourses(Map<String, dynamic> params);

  Future<PopularSearchesResponse> popularSearches(int limit);

  Future<bool> verifyInApp(String serverVerificationData, String price);

  Future<TokenAuthToCourse> getTokenToCourse(int courseId);
}

class CoursesRemoteDataSource extends CoursesDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<CoursesResponse> getCourses(Map<String, dynamic> params) async {
    try {
      Response response = await _httpService.dio.get(
        '/courses/',
        queryParameters: params,
      );
      return CoursesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response.toString());
    }
  }

  @override
  Future<PopularSearchesResponse> popularSearches(int limit) async {
    try {
      Response response = await _httpService.dio.get(
        '/popular_searches',
        queryParameters: {'limit': limit},
      );
      return PopularSearchesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<bool> verifyInApp(String serverVerificationData, String price) async {
    Response response = await _httpService.dio.post(
      '/verify_purchase',
      data: {'receipt': serverVerificationData, 'price': price},
      options: Options(
        headers: {'requirestoken': 'true'},
      ),
    );
    if (response.statusCode == 200) return true;
    return false;
  }

  @override
  Future<TokenAuthToCourse> getTokenToCourse(int courseId) async {
    try {
      Response response = await _httpService.dio.post(
        '/get_auth_token_to_course',
        data: {'course_id': courseId},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return TokenAuthToCourse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
