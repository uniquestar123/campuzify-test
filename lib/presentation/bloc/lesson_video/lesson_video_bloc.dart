import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import 'package:meta/meta.dart';

part 'lesson_video_event.dart';

part 'lesson_video_state.dart';

class LessonVideoBloc extends Bloc<LessonVideoEvent, LessonVideoState> {
  LessonVideoBloc() : super(InitialLessonVideoState()) {
    on<FetchEvent>((event, emit) async {
      emit(InitialLessonVideoState());
      try {
        LessonResponse response = await _lessonRepository.getLesson(event.courseId, event.lessonId);

        emit(LoadedLessonVideoState(response));
      } catch (e, s) {
        logger.e('Error with method getLesson in LessonVideoBloc - /course/lesson/ ', e, s);
        emit(ErrorLessonVideoState(e.toString()));
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
