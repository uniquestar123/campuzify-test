part of 'lesson_video_bloc.dart';

@immutable
abstract class LessonVideoState {}

class InitialLessonVideoState extends LessonVideoState {}

class LoadedLessonVideoState extends LessonVideoState {
  LoadedLessonVideoState(this.lessonResponse);

  final LessonResponse lessonResponse;
}

class ErrorLessonVideoState extends LessonVideoState {
  ErrorLessonVideoState(this.message);

  final String? message;
}
