part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class InitialHomeState extends HomeState {}

class LoadedHomeState extends HomeState {
  LoadedHomeState({
    required this.categoryList,
    required this.coursesTrending,
    required this.layout,
    required this.coursesNew,
    required this.coursesFree,
    required this.instructors,
    required this.appSettings,
  });

  final List<Category?> categoryList;
  final List<CoursesBean?> coursesTrending;
  final List<CoursesBean?> coursesNew;
  final List<CoursesBean?> coursesFree;
  final List<InstructorBean?> instructors;
  final List<HomeLayoutBean?> layout;
  final AppSettings appSettings;
}

class ErrorHomeState extends HomeState {}
