part of 'complete_lesson_bloc.dart';

abstract class CompleteLessonEvent {}

class UpdateLessonEvent extends CompleteLessonEvent {
  UpdateLessonEvent({
    required this.courseId,
    required this.lessonId,
  });

  final int courseId;
  final int lessonId;
}
