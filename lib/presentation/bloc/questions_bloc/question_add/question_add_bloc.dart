import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/repository/questions_repository.dart';

part 'question_add_event.dart';

part 'questions_add_state.dart';

class QuestionAddBloc extends Bloc<QuestionAddEvent, QuestionAddState> {
  QuestionAddBloc() : super(InitialQuestionAddState()) {
    on<AddQuestionEvent>((event, emit) async {
      emit(LoadingQuestionAddState());
      try {
        await _questionsRepository.addQuestion(
          lessonId: event.lessonId,
          comment: event.comment,
          parent: event.parent,
        );

        emit(SuccessQuestionAddState());
      } catch (e, s) {
        logger.e('Error completeLesson', e, s);
        emit(ErrorQuestionAddState(e.toString()));
      }
    });
  }

  final QuestionsRepository _questionsRepository = QuestionsRepositoryImpl();
}
