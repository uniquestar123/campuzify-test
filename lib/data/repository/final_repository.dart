import 'package:masterstudy_app/data/datasources/final_datasource.dart';
import 'package:masterstudy_app/data/models/final_response/final_response.dart';

abstract class FinalRepository {
  Future<FinalResponse> getCourseResults(int courseId);
}

class FinalRepositoryImpl implements FinalRepository {
  final FinalDataSource _finalDataSource = FinalRemoteDataSource();

  @override
  Future<FinalResponse> getCourseResults(int courseId) async => await _finalDataSource.getCourseResults(courseId);
}
