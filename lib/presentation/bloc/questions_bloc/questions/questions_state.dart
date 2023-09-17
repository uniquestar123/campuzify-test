part of 'questions_bloc.dart';

@immutable
abstract class QuestionsState {}

class InitialQuestionsState extends QuestionsState {}

class LoadedQuestionsState extends QuestionsState {
  LoadedQuestionsState(this.questionsResponseAll, this.questionsResponseMy);

  final QuestionsResponse questionsResponseAll;
  final QuestionsResponse questionsResponseMy;
}

class ErrorQuestionsState extends QuestionsState {}
