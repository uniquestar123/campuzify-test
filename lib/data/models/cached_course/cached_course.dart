import 'package:json_annotation/json_annotation.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';

part 'cached_course.g.dart';

@JsonSerializable(explicitToJson: true)
class CachedCourse {
  CachedCourse({
    required this.id,
    this.postsBean,
    required this.curriculumResponse,
    required this.lessons,
    required this.hash,
  });

  factory CachedCourse.fromJson(Map<String, dynamic> json) => _$CachedCourseFromJson(json);

  int id;
  String hash;
  PostsBean? postsBean;
  CurriculumResponse? curriculumResponse;
  List<LessonResponse?> lessons;

  Map<String, dynamic> toJson() => _$CachedCourseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CachedCourses {
  CachedCourses({required this.courses});

  factory CachedCourses.fromJson(Map<String, dynamic> json) => _$CachedCoursesFromJson(json);

  List<CachedCourse?> courses;

  Map<String, dynamic> toJson() => _$CachedCoursesToJson(this);
}
