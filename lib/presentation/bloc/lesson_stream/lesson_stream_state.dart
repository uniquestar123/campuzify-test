part of 'lesson_stream_bloc.dart';

@immutable
abstract class LessonStreamState {}

class InitialLessonStreamState extends LessonStreamState {}

class LoadedLessonStreamState extends LessonStreamState {
  LoadedLessonStreamState(this.lessonResponse);

  final LessonResponse lessonResponse;
}

class CacheWarningLessonStreamState extends LessonStreamState {}
