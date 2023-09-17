import 'dart:io';

import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/assignment/assignment_response.dart';

abstract class AssignmentDataSource {
  Future<AssignmentResponse> getAssignmentInfo(int course_id, int assignment_id);

  Future startAssignment(int course_id, int assignment_id);

  Future addAssignment(int course_id, int user_assignment_id, String content);

  Future<String> uploadAssignmentFile(int course_id, int user_assignment_id, File file);
}

class AssignmentRemoteDataSource extends AssignmentDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<AssignmentResponse> getAssignmentInfo(int course_id, int assignment_id) async {
    try {
      Map<String, int> map = {
        'course_id': course_id,
        'assignment_id': assignment_id,
      };

      Response response = await _httpService.dio.post(
        '/assignment',
        data: map,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return AssignmentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future startAssignment(int course_id, int assignment_id) async {
    try {
      Map<String, int> data = {
        'course_id': course_id,
        'assignment_id': assignment_id,
      };

      Response response = await _httpService.dio.put(
        '/assignment/start',
        data: data,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future addAssignment(int course_id, int user_assignment_id, String content) async {
    try {
      Map<String, dynamic> map = {
        'course_id': course_id,
        'user_assignment_id': user_assignment_id,
        'content': content,
      };

      Response response = await _httpService.dio.post(
        '/assignment/add',
        data: map,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<String> uploadAssignmentFile(int course_id, int user_assignment_id, File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'course_id': course_id,
        'user_assignment_id': user_assignment_id,
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      Response response = await _httpService.dio.post(
        '/assignment/add/file',
        data: formData,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );
      return response.toString();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
