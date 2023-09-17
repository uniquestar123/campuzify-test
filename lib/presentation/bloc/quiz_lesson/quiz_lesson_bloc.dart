import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/cache/cache_manager.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/quiz/quiz_response.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import 'package:meta/meta.dart';

part 'quiz_lesson_event.dart';

part 'quiz_lesson_state.dart';

class QuizLessonBloc extends Bloc<QuizLessonEvent, QuizLessonState> {
  QuizLessonBloc() : super(InitialQuizLessonState()) {
    on<LoadQuizLessonEvent>((event, emit) async {
      emit(InitialQuizLessonState());
      try {
        final response = await repository.getQuiz(event.courseId, event.lessonId);

        emit(LoadedQuizLessonState(response));
      } catch (e, s) {
        logger.e('Error with getQuiz', e, s);
        if (await cacheManager.isCached(event.courseId)) {
          emit(CacheWarningQuizLessonState());
        }
      }
    });
  }

  final LessonRepository repository = LessonRepositoryImpl();
  final CacheManager cacheManager = CacheManager();
}
