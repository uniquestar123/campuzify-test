part of 'final_bloc.dart';

@immutable
abstract class FinalEvent {}

class LoadFinalEvent extends FinalEvent {
  LoadFinalEvent(this.courseId);

  final int courseId;
}
