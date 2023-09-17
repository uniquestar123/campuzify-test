import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import 'package:meta/meta.dart';

part 'zoom_event.dart';

part 'zoom_state.dart';

class LessonZoomBloc extends Bloc<LessonZoomEvent, LessonZoomState> {
  LessonZoomBloc() : super(InitialLessonZoomState()) {
    on<FetchEvent>((event, emit) async {
      try {
        LessonResponse response = await _lessonRepository.getLesson(event.courseId, event.lessonId);

        emit(LoadedLessonZoomState(response));
      } catch (e, s) {
        logger.e('Error completeLesson', e, s);
      }
    });

    on<CompleteLessonEvent>((event, emit) async {
      try {
        await _lessonRepository.completeLesson(event.courseId, event.lessonId);
      } catch (e, s) {
        logger.e('Error completeLesson', e, s);
      }
    });
  }

  final LessonRepository _lessonRepository = LessonRepositoryImpl();
}
