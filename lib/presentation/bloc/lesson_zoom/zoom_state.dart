part of 'zoom_bloc.dart';

@immutable
abstract class LessonZoomState {}

class InitialLessonZoomState extends LessonZoomState {}

class LoadedLessonZoomState extends LessonZoomState {
  LoadedLessonZoomState(this.lessonResponse);

  final LessonResponse lessonResponse;
}
