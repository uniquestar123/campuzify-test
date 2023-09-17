import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/cache/cache_manager.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import 'package:meta/meta.dart';

part 'lesson_stream_event.dart';

part 'lesson_stream_state.dart';

class LessonStreamBloc extends Bloc<LessonStreamEvent, LessonStreamState> {
  LessonStreamBloc() : super(InitialLessonStreamState()) {
    on<FetchEvent>((event, emit) async {
      emit(InitialLessonStreamState());
      try {
        final response = await repository.getLesson(event.courseId, event.lessonId);
        emit(LoadedLessonStreamState(response));
      } catch (e, s) {
        logger.e('Error with method getLesson() - Lesson Stream Bloc', e, s);
        if (await cacheManager.isCached(event.courseId)) {
          emit(CacheWarningLessonStreamState());
        }
      }
    });
  }

  final LessonRepository repository = LessonRepositoryImpl();
  final CacheManager cacheManager = CacheManager();
}
