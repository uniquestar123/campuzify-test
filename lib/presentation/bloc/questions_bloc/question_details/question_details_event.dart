part of 'question_details_bloc.dart';

@immutable
abstract class QuestionDetailsEvent {}

class QuestionAddEvent extends QuestionDetailsEvent {
  QuestionAddEvent(this.lessonId, this.comment, this.parent);

  final int lessonId;
  final String comment;
  final int parent;
}
