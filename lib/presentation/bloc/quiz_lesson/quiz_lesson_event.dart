part of 'quiz_lesson_bloc.dart';

@immutable
abstract class QuizLessonEvent {}

class LoadQuizLessonEvent extends QuizLessonEvent {
  LoadQuizLessonEvent(this.courseId, this.lessonId);

  final int courseId;
  final int lessonId;
}
