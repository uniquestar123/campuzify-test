part of 'search_screen_bloc.dart';

@immutable
abstract class SearchScreenState {}

class InitialSearchScreenState extends SearchScreenState {}

class ErrorSearchScreenState extends SearchScreenState {}

class LoadedSearchScreenState extends SearchScreenState {
  LoadedSearchScreenState(this.newCourses, this.popularSearch);

  final List<CoursesBean?> newCourses;
  final List<String?> popularSearch;
}

class ResultsSearchScreenState extends SearchScreenState {
  ResultsSearchScreenState(this.courses);

  final List<CoursesBean> courses;
}
