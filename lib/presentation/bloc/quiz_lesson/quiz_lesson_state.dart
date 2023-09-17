part of 'quiz_lesson_bloc.dart';

@immutable
abstract class QuizLessonState {}

class InitialQuizLessonState extends QuizLessonState {}

class CacheWarningQuizLessonState extends QuizLessonState {}

class LoadedQuizLessonState extends QuizLessonState {
  LoadedQuizLessonState(this.quizResponse);

  final QuizResponse quizResponse;
}
