part of 'questions_bloc.dart';

@immutable
abstract class QuestionsEvent {}

class LoadQuestionsEvent extends QuestionsEvent {
  LoadQuestionsEvent(this.lessonId, this.page, this.search, this.authorIn);

  final int lessonId;
  final int page;
  final String search;
  final String authorIn;
}
