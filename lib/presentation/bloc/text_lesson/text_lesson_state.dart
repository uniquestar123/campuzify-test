part of 'text_lesson_bloc.dart';

@immutable
abstract class TextLessonState {}

class InitialTextLessonState extends TextLessonState {}

class CacheWarningLessonState extends TextLessonState {}

class LoadedTextLessonState extends TextLessonState {
  LoadedTextLessonState(this.lessonResponse);

  final LessonResponse lessonResponse;
}

class ErrorTextLessonState extends TextLessonState {
  ErrorTextLessonState(this.message);

  final String? message;
}

// State of Complete Event
class LoadingCompleteState extends TextLessonState {}

class SuccessCompleteState extends TextLessonState {}

class ErrorCompleteState extends TextLessonState {}
