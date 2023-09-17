import 'package:masterstudy_app/core/cache/course_curriculum_local.dart';
import 'package:masterstudy_app/core/cache/progress_course_local.dart';
import 'package:masterstudy_app/data/datasources/user_course_datasource.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';

abstract class UserCourseRepository {
  Future<UserCourseResponse> getUserCourses();

  Future<CurriculumResponse> getCourseCurriculum(int id);

  Future<CourseDetailResponse> getCourse(int courseId);

  void saveLocalUserCourses(UserCourseResponse userCourseResponse);

  Future<List<UserCourseResponse>> getUserCoursesLocal();

  void saveLocalCurriculum(CurriculumResponse curriculumResponse, int id);

  Future<List<CurriculumResponse>> getCurriculumLocal(int id);
}

class UserCourseRepositoryImpl extends UserCourseRepository {
  final UserCourseDataSource _userCourseDataSource = UserCourseRemoteDataSource();
  final ProgressCoursesLocalStorage _progressCoursesLocalStorage = ProgressCoursesLocalStorage();
  final CurriculumLocalStorage _curriculumLocalStorage = CurriculumLocalStorage();

  @override
  Future<UserCourseResponse> getUserCourses() async => await _userCourseDataSource.getUserCourses();

  @override
  Future<CurriculumResponse> getCourseCurriculum(int id) async => await _userCourseDataSource.getCourseCurriculum(id);

  @override
  Future<CourseDetailResponse> getCourse(int courseId) async => await _userCourseDataSource.getCourse(courseId);

  @override
  void saveLocalUserCourses(UserCourseResponse userCourseResponse) {
    return _progressCoursesLocalStorage.saveProgressCourses(userCourseResponse);
  }

  @override
  Future<List<UserCourseResponse>> getUserCoursesLocal() async {
    return _progressCoursesLocalStorage.getUserCoursesLocal();
  }

  @override
  void saveLocalCurriculum(CurriculumResponse curriculumResponse, int id) {
    return _curriculumLocalStorage.saveCurriculum(curriculumResponse, id);
  }

  @override
  Future<List<CurriculumResponse>> getCurriculumLocal(int id) async {
    return _curriculumLocalStorage.getCurriculumLocal(id);
  }
}
