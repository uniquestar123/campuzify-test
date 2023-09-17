part of 'user_course_locked_bloc.dart';

@immutable
abstract class UserCourseLockedState {}

class InitialUserCourseLockedState extends UserCourseLockedState {}

class LoadedUserCourseLockedState extends UserCourseLockedState {
  LoadedUserCourseLockedState(this.courseDetailResponse);

  final CourseDetailResponse courseDetailResponse;
}
