part of 'lesson_video_bloc.dart';

@immutable
abstract class LessonVideoEvent {}

class FetchEvent extends LessonVideoEvent {
  FetchEvent(this.courseId, this.lessonId);

  final int courseId;
  final int lessonId;
}

class CompleteLessonEvent extends LessonVideoEvent {
  CompleteLessonEvent(this.courseId, this.lessonId);

  final int courseId;
  final int lessonId;
}
