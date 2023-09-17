import 'package:json_annotation/json_annotation.dart';

part 'final_response.g.dart';

@JsonSerializable()
class FinalResponse {
  FinalResponse({
    this.course,
    this.curriculum,
    this.url,
    this.certificateUrl,
    required this.title,
    required this.courseCompleted,
  });

  factory FinalResponse.fromJson(Map<String, dynamic> json) => _$FinalResponseFromJson(json);

  final CourseBean? course;
  final CurriculumBean? curriculum;
  @JsonKey(name: 'course_completed', defaultValue: false)
  final bool courseCompleted;
  final String? title;
  final String? url;
  @JsonKey(name: 'certificate_url')
  final String? certificateUrl;

  Map<String, dynamic> toJson() => _$FinalResponseToJson(this);
}

@JsonSerializable()
class CourseBean {
  CourseBean({
    this.userId,
    this.courseId,
    this.currentLessonId,
    required this.progressPercent,
    this.status,
    this.subscriptionId,
    this.startTime,
    this.lngCode,
    this.enterpriseId,
    this.bundleId,
    required this.userCourseId,
  });

  factory CourseBean.fromJson(Map<String, dynamic> json) => _$CourseBeanFromJson(json);

  @JsonKey(name: 'user_course_id')
  final num? userCourseId;
  @JsonKey(name: 'user_id')
  final num? userId;
  @JsonKey(name: 'course_id')
  final int? courseId;
  @JsonKey(name: 'current_lesson_id')
  final num? currentLessonId;
  @JsonKey(name: 'progress_percent')
  final int progressPercent;
  final String? status;
  @JsonKey(name: 'subscription_id')
  final num? subscriptionId;
  @JsonKey(name: 'start_time')
  final String? startTime;
  @JsonKey(name: 'lng_code')
  final String? lngCode;
  @JsonKey(name: 'enterprise_id')
  final num? enterpriseId;
  @JsonKey(name: 'bundle_id')
  final num? bundleId;

  Map<String, dynamic> toJson() => _$CourseBeanToJson(this);
}

@JsonSerializable()
class CurriculumBean {
  CurriculumBean({required this.multimedia, required this.lesson, required this.assignment, required this.quiz});

  factory CurriculumBean.fromJson(Map<String, dynamic> json) => _$CurriculumBeanFromJson(json);

  final TypeBean? multimedia;
  final TypeBean? lesson;
  final TypeBean? quiz;
  final TypeBean? assignment;

  Map<String, dynamic> toJson() => _$CurriculumBeanToJson(this);
}

@JsonSerializable()
class TypeBean {
  TypeBean({required this.total, required this.completed});

  factory TypeBean.fromJson(Map<String, dynamic> json) => _$TypeBeanFromJson(json);

  final num total;
  final num completed;

  Map<String, dynamic> toJson() => _$TypeBeanToJson(this);
}
