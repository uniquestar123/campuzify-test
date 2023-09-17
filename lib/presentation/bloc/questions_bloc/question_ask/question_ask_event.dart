part of 'question_ask_bloc.dart';

@immutable
abstract class QuestionAskEvent {}

class QuestionAddEvent extends QuestionAskEvent {
  QuestionAddEvent(this.lessonId, this.comment);

  final int lessonId;
  final String comment;
}
