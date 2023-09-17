import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/cache/cache_manager.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import 'package:meta/meta.dart';

part 'text_lesson_event.dart';

part 'text_lesson_state.dart';

class TextLessonBloc extends Bloc<TextLessonEvent, TextLessonState> {
  TextLessonBloc() : super(InitialTextLessonState()) {
    on<FetchEvent>((event, emit) async {
      emit(InitialTextLessonState());
      try {
        final response = await repository.getLesson(event.courseId, event.lessonId);
        emit(LoadedTextLessonState(response));
      } catch (e, s) {
        logger.e('Error with method getLesson() - "/course/lesson"', e, s);
        emit(ErrorTextLessonState(e.toString()));
      }
    });
  }

  final LessonRepository repository = LessonRepositoryImpl();
  final CacheManager cacheManager = CacheManager();
}
