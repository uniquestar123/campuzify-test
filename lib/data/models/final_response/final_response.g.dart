// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'final_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinalResponse _$FinalResponseFromJson(Map<String, dynamic> json) =>
    FinalResponse(
      course: json['course'] == null
          ? null
          : CourseBean.fromJson(json['course'] as Map<String, dynamic>),
      curriculum: json['curriculum'] == null
          ? null
          : CurriculumBean.fromJson(json['curriculum'] as Map<String, dynamic>),
      url: json['url'] as String?,
      certificateUrl: json['certificate_url'] as String?,
      title: json['title'] as String?,
      courseCompleted: json['course_completed'] as bool? ?? false,
    );

Map<String, dynamic> _$FinalResponseToJson(FinalResponse instance) =>
    <String, dynamic>{
      'course': instance.course,
      'curriculum': instance.curriculum,
      'course_completed': instance.courseCompleted,
      'title': instance.title,
      'url': instance.url,
      'certificate_url': instance.certificateUrl,
    };

CourseBean _$CourseBeanFromJson(Map<String, dynamic> json) => CourseBean(
      userId: json['user_id'] as num?,
      courseId: json['course_id'] as int?,
      currentLessonId: json['current_lesson_id'] as num?,
      progressPercent: json['progress_percent'] as int,
      status: json['status'] as String?,
      subscriptionId: json['subscription_id'] as num?,
      startTime: json['start_time'] as String?,
      lngCode: json['lng_code'] as String?,
      enterpriseId: json['enterprise_id'] as num?,
      bundleId: json['bundle_id'] as num?,
      userCourseId: json['user_course_id'] as num?,
    );

Map<String, dynamic> _$CourseBeanToJson(CourseBean instance) =>
    <String, dynamic>{
      'user_course_id': instance.userCourseId,
      'user_id': instance.userId,
      'course_id': instance.courseId,
      'current_lesson_id': instance.currentLessonId,
      'progress_percent': instance.progressPercent,
      'status': instance.status,
      'subscription_id': instance.subscriptionId,
      'start_time': instance.startTime,
      'lng_code': instance.lngCode,
      'enterprise_id': instance.enterpriseId,
      'bundle_id': instance.bundleId,
    };

CurriculumBean _$CurriculumBeanFromJson(Map<String, dynamic> json) =>
    CurriculumBean(
      multimedia: json['multimedia'] == null
          ? null
          : TypeBean.fromJson(json['multimedia'] as Map<String, dynamic>),
      lesson: json['lesson'] == null
          ? null
          : TypeBean.fromJson(json['lesson'] as Map<String, dynamic>),
      assignment: json['assignment'] == null
          ? null
          : TypeBean.fromJson(json['assignment'] as Map<String, dynamic>),
      quiz: json['quiz'] == null
          ? null
          : TypeBean.fromJson(json['quiz'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurriculumBeanToJson(CurriculumBean instance) =>
    <String, dynamic>{
      'multimedia': instance.multimedia,
      'lesson': instance.lesson,
      'quiz': instance.quiz,
      'assignment': instance.assignment,
    };

TypeBean _$TypeBeanFromJson(Map<String, dynamic> json) => TypeBean(
      total: json['total'] as num,
      completed: json['completed'] as num,
    );

Map<String, dynamic> _$TypeBeanToJson(TypeBean instance) => <String, dynamic>{
      'total': instance.total,
      'completed': instance.completed,
    };
