part of 'user_course_locked_bloc.dart';


@immutable
abstract class UserCourseLockedEvent {}

class FetchEvent extends UserCourseLockedEvent {
  FetchEvent(this.courseId);

  final int courseId;
}
