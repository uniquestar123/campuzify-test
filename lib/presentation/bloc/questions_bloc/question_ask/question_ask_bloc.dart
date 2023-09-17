import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/question_add/question_add_response.dart';
import 'package:masterstudy_app/data/repository/questions_repository.dart';
import 'package:meta/meta.dart';

part 'question_ask_event.dart';

part 'question_ask_state.dart';

class QuestionAskBloc extends Bloc<QuestionAskEvent, QuestionAskState> {
  QuestionAskBloc() : super(InitialQuestionAskState()) {
    on<QuestionAddEvent>((event, emit) async {
      emit(LoadingAddQuestionState());
      try {
        await _questionsRepository.addQuestion(
          lessonId: event.lessonId,
          comment: event.comment,
          parent: 0,
        );

        emit(SuccessAddQuestionState());
      } catch (e, s) {
        logger.e('Error addQuestion', e, s);
        emit(ErrorAddQuestionState(e.toString()));
      }
    });
  }

  final QuestionsRepository _questionsRepository = QuestionsRepositoryImpl();
}
