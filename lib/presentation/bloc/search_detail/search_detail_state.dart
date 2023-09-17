part of 'search_detail_bloc.dart';

@immutable
abstract class SearchDetailState {}

class InitialSearchDetailState extends SearchDetailState {}

class LoadingSearchDetailState extends SearchDetailState {}

class LoadedSearchDetailState extends SearchDetailState {
  LoadedSearchDetailState(this.courses);

  final List<CoursesBean?> courses;
}

class NotingFoundSearchDetailState extends SearchDetailState {}

class ErrorSearchDetailState extends SearchDetailState {}
