part of 'home_simple_bloc.dart';

@immutable
abstract class HomeSimpleState {}

class InitialHomeSimpleState extends HomeSimpleState {}

class LoadedHomeSimpleState extends HomeSimpleState {
  LoadedHomeSimpleState(this.coursesNew);

  final List<CoursesBean?> coursesNew;
}

class EmptyHomeSimpleState extends HomeSimpleState {}

class ErrorHomeSimpleState extends HomeSimpleState {}
