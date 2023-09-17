import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/data/models/quiz/quiz_response.dart';

abstract class LessonDataSource {
  Future<LessonResponse> getLesson(int courseId, int lessonId);

  Future completeLesson(int courseId, int lessonId);

  Future<QuizResponse> getQuiz(int courseId, int lessonId);
}

class LessonRemoteDataSource extends LessonDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<LessonResponse> getLesson(int courseId, int lessonId) async {
    try {
      Response response = await _httpService.dio.post(
        '/course/lesson',
        data: {'course_id': courseId, 'item_id': lessonId},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return LessonResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future completeLesson(int courseId, int lessonId) async {
    try {
      await _httpService.dio.put(
        '/course/lesson/complete',
        data: {'course_id': courseId, 'item_id': lessonId},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.message);
    }

    return;
  }

  @override
  Future<QuizResponse> getQuiz(int courseId, int lessonId) async {
    try {
      Response response = await _httpService.dio.post(
        '/course/quiz',
        data: {'course_id': courseId, 'item_id': lessonId},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );
      return QuizResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
