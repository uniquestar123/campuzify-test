import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';

abstract class FavouriteDataSource {
  Future<CoursesResponse> getFavoriteCourses();

  Future addFavoriteCourse(int courseId);

  Future deleteFavoriteCourse(int courseId);
}

class FavouriteRemoteDataSource extends FavouriteDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<CoursesResponse> getFavoriteCourses() async {
    try {
      Response response = await _httpService.dio.get(
        '/courses?wishlist=1',
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );
      return CoursesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future addFavoriteCourse(int courseId) async {
    try {
      Response response = await _httpService.dio.put(
        '/favorite',
        queryParameters: {'id': courseId},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future deleteFavoriteCourse(int courseId) async {
    try {
      Response response = await _httpService.dio.delete(
        '/favorite',
        queryParameters: {'id': courseId},
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
