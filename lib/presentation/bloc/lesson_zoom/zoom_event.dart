part of 'zoom_bloc.dart';

@immutable
abstract class LessonZoomEvent {}

class FetchEvent extends LessonZoomEvent {
  FetchEvent(this.courseId, this.lessonId);

  final int courseId;
  final int lessonId;
}

class CompleteLessonEvent extends LessonZoomEvent {
  CompleteLessonEvent(this.courseId, this.lessonId);

  final int courseId;
  final int lessonId;
}
