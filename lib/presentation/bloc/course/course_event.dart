part of 'course_bloc.dart';

@immutable
abstract class CourseEvent {}

class FetchEvent extends CourseEvent {
  FetchEvent(this.courseId);

  final int courseId;
}

class PaymentSelectedEvent extends CourseEvent {
  PaymentSelectedEvent(this.selectedPaymentId, this.courseId);

  final int selectedPaymentId;
  final int courseId;
}

class DeleteFromFavorite extends CourseEvent {
  DeleteFromFavorite(this.courseId);

  final int courseId;
}

class AddToFavorite extends CourseEvent {
  AddToFavorite(this.courseId);

  final int courseId;
}

class AddToCart extends CourseEvent {
  AddToCart(this.courseId);

  final int courseId;
}

class UsePlan extends CourseEvent {
  UsePlan(this.courseId);

  final int courseId;
}

class GetTokenToCourse extends CourseEvent {
  GetTokenToCourse(this.courseId);

  final int courseId;
}
