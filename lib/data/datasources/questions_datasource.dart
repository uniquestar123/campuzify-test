import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/question_add/question_add_response.dart';
import 'package:masterstudy_app/data/models/questions/questions_response.dart';

abstract class QuestionsDataSource {
  Future<QuestionsResponse> getQuestions(int lessonId, int page, String search, String authorIn);

  Future<QuestionAddResponse> addQuestion({required int lessonId, required String comment, required int parent});
}

class QuestionsRemoteDataSource extends QuestionsDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<QuestionsResponse> getQuestions(int lessonId, int page, String search, String authorIn) async {
    try {
      Map<String, dynamic> map = {
        'id': lessonId,
        'page': page,
      };

      if (search != '') map['search'] = search;

      if (authorIn != '') map['author__in'] = authorIn;

      Response response = await _httpService.dio.post(
        '/lesson/questions',
        data: map,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return QuestionsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<QuestionAddResponse> addQuestion({required int lessonId, required String comment, required int parent}) async {
    Map<String, dynamic> data = {
      'id': lessonId,
      'comment': comment,
      'parent': parent,
    };

    try {
      Response response = await _httpService.dio.put(
        '/lesson/questions',
        data: data,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return QuestionAddResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('SMS can be sent every 20 seconds');
      } else {
        throw Exception(e.message);
      }
    }
  }
}
