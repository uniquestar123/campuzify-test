part of 'question_ask_bloc.dart';

@immutable
abstract class QuestionAskState {}

class InitialQuestionAskState extends QuestionAskState {}

class LoadingAddQuestionState extends QuestionAskState {}

class SuccessAddQuestionState extends QuestionAskState {}

class LoadedQuestionAskState extends QuestionAskState {}

class QuestionAddedState extends QuestionAskState {
  QuestionAddedState(this.questionAddResponse);

  final QuestionAddResponse questionAddResponse;
}

class ErrorAddQuestionState extends QuestionAskState {
  ErrorAddQuestionState(this.message);

  final String? message;
}
