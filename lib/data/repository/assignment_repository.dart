import 'dart:io';

import 'package:masterstudy_app/data/datasources/assignment_datasource.dart';
import 'package:masterstudy_app/data/models/assignment/assignment_response.dart';

abstract class AssignmentRepository {
  Future<AssignmentResponse> getAssignmentInfo(int course_id, int assignment_id);

  Future startAssignment(int course_id, int assignment_id);

  Future addAssignment(int course_id, int user_assignment_id, String content);

  Future<String> uploadAssignmentFile(int course_id, int user_assignment_id, File file);
}

class AssignmentRepositoryImpl extends AssignmentRepository {
  final AssignmentDataSource _assignmentDataSource = AssignmentRemoteDataSource();

  @override
  Future<AssignmentResponse> getAssignmentInfo(int course_id, int assignment_id) async {
    return await _assignmentDataSource.getAssignmentInfo(course_id, assignment_id);
  }

  @override
  Future startAssignment(int course_id, int assignment_id) async {
    return await _assignmentDataSource.startAssignment(course_id, assignment_id);
  }

  @override
  Future addAssignment(int course_id, int user_assignment_id, String content) async {
    return await _assignmentDataSource.addAssignment(course_id, user_assignment_id, content);
  }

  @override
  Future<String> uploadAssignmentFile(int course_id, int user_assignment_id, File file) async {
    return await _assignmentDataSource.uploadAssignmentFile(course_id, user_assignment_id, file);
  }
}
