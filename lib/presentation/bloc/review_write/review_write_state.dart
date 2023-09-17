part of 'review_write_bloc.dart';

@immutable
abstract class ReviewWriteState {}

class InitialReviewWriteState extends ReviewWriteState {}

class LoadedReviewWriteState extends ReviewWriteState {
  LoadedReviewWriteState(this.account);

  final Account account;
}

class LoadingAddReviewState extends ReviewWriteState {}

class SuccessAddReviewState extends ReviewWriteState {
  SuccessAddReviewState(this.reviewAddResponse,this.account);

  final ReviewAddResponse reviewAddResponse;
  final Account account;
}

class ErrorAddReviewState extends ReviewWriteState {
  ErrorAddReviewState({this.message});

  final String? message;
}

class ErrorLoadedReviewState extends ReviewWriteState {
  ErrorLoadedReviewState({this.message});

  final String? message;
}
