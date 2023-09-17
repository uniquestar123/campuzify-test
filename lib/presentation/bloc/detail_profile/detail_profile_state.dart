part of 'detail_profile_bloc.dart';

@immutable
abstract class DetailProfileState {}

class InitialDetailProfileState extends DetailProfileState {}

class LoadedDetailProfileState extends DetailProfileState {
  LoadedDetailProfileState(this.courses, this.isTeacher);

  final List<CoursesBean?>? courses;
  final bool isTeacher;
}
