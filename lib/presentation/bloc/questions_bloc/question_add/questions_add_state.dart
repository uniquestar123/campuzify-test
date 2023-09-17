part of 'question_add_bloc.dart';

abstract class QuestionAddState {}

class InitialQuestionAddState extends QuestionAddState {}

class LoadingQuestionAddState extends QuestionAddState {}

class SuccessQuestionAddState extends QuestionAddState {}

class ErrorQuestionAddState extends QuestionAddState {
  ErrorQuestionAddState(this.message);

  final String message;
}
