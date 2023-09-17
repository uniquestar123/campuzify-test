import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';

part 'complete_lesson_event.dart';

part 'complete_lesson_state.dart';

class CompleteLessonBloc extends Bloc<CompleteLessonEvent, CompleteLessonState> {
  CompleteLessonBloc() : super(InitialCompleteLessonState()) {
    on<UpdateLessonEvent>((event, emit) async {
      emit(LoadingCompleteLessonState());
      try {
        await repository.completeLesson(event.courseId, event.lessonId);
        emit(SuccessCompleteLessonState());
      } catch (e, s) {
        logger.e('Error completeLesson', e, s);
        emit(ErrorCompleteLessonState());
      }
    });
  }

  final LessonRepository repository = LessonRepositoryImpl();
}
