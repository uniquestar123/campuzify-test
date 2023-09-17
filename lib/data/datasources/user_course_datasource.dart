import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';

abstract class UserCourseDataSource {
  Future<CourseDetailResponse> getCourse(int id);

  Future<UserCourseResponse> getUserCourses();

  Future<CurriculumResponse> getCourseCurriculum(int id);
}

class UserCourseRemoteDataSource extends UserCourseDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<CourseDetailResponse> getCourse(int id) async {
    try {
      Response response = await _httpService.dio.get(
        '/course',
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
        queryParameters: {'id': id},
      );

      return CourseDetailResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserCourseResponse> getUserCourses() async {
    try {
      Response response = await _httpService.dio.post(
        '/user_courses?page=0',
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return UserCourseResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CurriculumResponse> getCourseCurriculum(int id) async {
    try {
      Response response = await _httpService.dio.post(
        '/course_curriculum',
        data: {'id': id},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return CurriculumResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
