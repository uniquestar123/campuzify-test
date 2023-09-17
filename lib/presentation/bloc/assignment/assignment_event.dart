part of 'assignment_bloc.dart';

@immutable
abstract class AssignmentEvent {}

class LoadAssignmentEvent extends AssignmentEvent {
  LoadAssignmentEvent(this.courseId, this.assignmentId);

  final int courseId;
  final int assignmentId;
}

class StartAssignmentEvent extends AssignmentEvent {
  StartAssignmentEvent(this.courseId, this.assignmentId);

  final int courseId;
  final int assignmentId;
}

class AddAssignmentEvent extends AssignmentEvent {
  AddAssignmentEvent(this.courseId, this.assignmentId, this.userAssignmentId, this.content, this.files);

  final int courseId;
  final int assignmentId;
  final int userAssignmentId;
  final String content;
  final List<File> files;
}
