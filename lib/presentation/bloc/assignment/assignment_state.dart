part of 'assignment_bloc.dart';

@immutable
abstract class AssignmentState {}

class InitialAssignmentState extends AssignmentState {}

class LoadedAssignmentState extends AssignmentState {
  LoadedAssignmentState(this.assignmentResponse);

  final AssignmentResponse assignmentResponse;
}

class ErrorAssignmentState extends AssignmentState {
  ErrorAssignmentState(this.message);

  final String? message;
}

// State of Start Assignment State
class LoadingStartAssignmentState extends AssignmentState {}

class ErrorStartAssignmentState extends AssignmentState {
  ErrorStartAssignmentState(this.message);

  final String? message;
}

// State of Add Assignment State

class LoadingAddAssignmentState extends AssignmentState {}

class ErrorAddAssignmentState extends AssignmentState {
  ErrorAddAssignmentState(this.message);

  final String? message;
}

class CacheWarningAssignmentState extends AssignmentState {}
