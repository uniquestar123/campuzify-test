part of 'course_bloc.dart';

@immutable
abstract class CourseState {}

class InitialCourseState extends CourseState {}

class OpenPurchaseState extends CourseState {
  OpenPurchaseState(this.url);

  final String url;
}

class LoadedCourseState extends CourseState {
  LoadedCourseState(this.courseDetailResponse, this.reviewResponse, {this.userPlans});

  final CourseDetailResponse courseDetailResponse;
  final ReviewResponse reviewResponse;
  final UserPlansResponse? userPlans;
}

class LoadingGetTokenToCourseState extends CourseState {}

class SuccessGetTokenToCourseState extends CourseState {
  SuccessGetTokenToCourseState(this.tokenAuth);

  final String tokenAuth;
}

class ErrorGetTokenToCourseState extends CourseState {
  ErrorGetTokenToCourseState(this.message);

  final String? message;
}

class ErrorCourseState extends CourseState {
  ErrorCourseState(this.message);

  final String? message;
}
