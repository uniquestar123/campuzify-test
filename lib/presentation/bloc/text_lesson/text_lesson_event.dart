part of 'text_lesson_bloc.dart';

@immutable
abstract class TextLessonEvent {}

class FetchEvent extends TextLessonEvent {
  FetchEvent(this.courseId, this.lessonId);

  final int courseId;
  final int lessonId;
}
