import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/question_add/question_add_response.dart';
import 'package:masterstudy_app/data/repository/questions_repository.dart';
import 'package:meta/meta.dart';

part 'question_details_event.dart';

part 'question_details_state.dart';

class QuestionDetailsBloc extends Bloc<QuestionDetailsEvent, QuestionDetailsState> {
  QuestionDetailsBloc() : super(InitialQuestionDetailsState()) {
    on<QuestionAddEvent>((event, emit) async {
      emit(ReplyAddingState());
      try {
        QuestionAddResponse addAnswer = await _questionsRepository.addQuestion(
          lessonId: event.lessonId,
          comment: event.comment,
          parent: event.parent,
        );

        emit(ReplyAddedState(addAnswer));
      } catch (e, s) {
        logger.e('Error addQuestion', e, s);
        emit(ReplyErrorState(e.toString()));
      }
    });
  }

  final QuestionsRepository _questionsRepository = QuestionsRepositoryImpl();
}
