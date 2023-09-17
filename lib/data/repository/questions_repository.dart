import 'package:masterstudy_app/data/datasources/questions_datasource.dart';
import 'package:masterstudy_app/data/models/question_add/question_add_response.dart';
import 'package:masterstudy_app/data/models/questions/questions_response.dart';

abstract class QuestionsRepository {
  Future<QuestionsResponse> getQuestions(int lessonId, int page, String search, String authorIn);

  Future<QuestionAddResponse> addQuestion({required int lessonId, required String comment, required int parent});
}

class QuestionsRepositoryImpl extends QuestionsRepository {
  final QuestionsDataSource _questionsDataSource = QuestionsRemoteDataSource();

  @override
  Future<QuestionsResponse> getQuestions(int lessonId, int page, String search, String authorIn) async {
    return await _questionsDataSource.getQuestions(lessonId, page, search, authorIn);
  }

  @override
  Future<QuestionAddResponse> addQuestion({required int lessonId, required String comment, required int parent}) async {
    return await _questionsDataSource.addQuestion(lessonId: lessonId,comment: comment,parent: parent);
  }
}
