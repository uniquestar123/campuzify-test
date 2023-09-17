part of 'user_course_bloc.dart';

@immutable
abstract class UserCourseEvent {}

class FetchEvent extends UserCourseEvent {
  FetchEvent(this.userCourseScreenArgs);

  final UserCourseScreenArgs userCourseScreenArgs;
}

class CacheCourseEvent extends UserCourseEvent {
  CacheCourseEvent(this.userCourseScreenArgs);

  final UserCourseScreenArgs userCourseScreenArgs;
}
