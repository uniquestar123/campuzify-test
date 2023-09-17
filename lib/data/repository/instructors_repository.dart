import 'package:masterstudy_app/core/extensions/basic_extensions.dart';
import 'package:masterstudy_app/data/datasources/instructor_datasource.dart';
import 'package:masterstudy_app/data/models/instructors/instructors_response.dart';

enum InstructorsSort { rating }

abstract class InstructorsRepository {
  Future<List<InstructorBean?>> getInstructors(InstructorsSort sort, {int page, int perPage});
}

class InstructorsRepositoryImpl extends InstructorsRepository {
  final InstructorDataSource _instructorDataSource = InstructorRemoteDataSource();

  @override
  Future<List<InstructorBean?>> getInstructors(InstructorsSort sort, {int? page, int? perPage}) async {
    Map<String, dynamic> query = Map();

    switch (sort) {
      case InstructorsSort.rating:
        query.addParam('sort', 'rating');
        break;
    }

    return (await _instructorDataSource.getInstructors(query)).data;
  }
}
