part of 'question_add_bloc.dart';

abstract class QuestionAddEvent {}

class AddQuestionEvent extends QuestionAddEvent {
  AddQuestionEvent({
    required this.lessonId,
    required this.comment,
    required this.parent,
  });

  final int lessonId;
  final String comment;
  final int parent;
}
