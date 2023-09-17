part of 'review_write_bloc.dart';

@immutable
abstract class ReviewWriteEvent {}

class FetchEvent extends ReviewWriteEvent {
  FetchEvent(this.courseId);

  final int courseId;
}

class SaveReviewEvent extends ReviewWriteEvent {
  SaveReviewEvent(this.id, this.mark, this.review);

  final int id;
  final int mark;
  final String review;
}
