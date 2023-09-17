part of 'user_courses_bloc.dart';

abstract class UserCoursesState {
  const UserCoursesState();
}

class InitialUserCoursesState extends UserCoursesState {}

class ErrorUserCoursesState extends UserCoursesState {}

class EmptyCoursesState extends UserCoursesState {}

class EmptyCacheCoursesState extends UserCoursesState {}

class LoadedCoursesState extends UserCoursesState {
  LoadedCoursesState(this.courses);

  final List<PostsBean?> courses;
}

class UnauthorizedState extends UserCoursesState {}
