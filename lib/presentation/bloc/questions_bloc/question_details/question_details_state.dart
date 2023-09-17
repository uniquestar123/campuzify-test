part of 'question_details_bloc.dart';

@immutable
abstract class QuestionDetailsState {}

class InitialQuestionDetailsState extends QuestionDetailsState {}

class ReplyAddingState extends QuestionDetailsState {}

class ReplyAddedState extends QuestionDetailsState {
  ReplyAddedState(this.questionAddResponse);

  final QuestionAddResponse questionAddResponse;
}

class ReplyErrorState extends QuestionDetailsState {
  ReplyErrorState(this.message);

  final String message;
}
