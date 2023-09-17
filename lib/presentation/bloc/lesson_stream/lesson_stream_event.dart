part of 'lesson_stream_bloc.dart';

@immutable
abstract class LessonStreamEvent {}

class FetchEvent extends LessonStreamEvent {
  FetchEvent(this.courseId, this.lessonId);

  final int courseId;
  final int lessonId;
}
