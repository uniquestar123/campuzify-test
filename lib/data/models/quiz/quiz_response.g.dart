// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizResponse _$QuizResponseFromJson(Map<String, dynamic> json) => QuizResponse(
      section: json['section'] == null ? null : SectionBean.fromJson(json['section'] as Map<String, dynamic>),
      title: json['title'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      video: json['video'] as String,
      prevLessonType: json['prev_lesson_type'] as String,
      nextLessonType: json['next_lesson_type'] as String,
      prevLesson: json['prev_lesson'] as int?,
      nextLesson: json['next_lesson'] as int?,
      viewLink: json['view_link'] as String,
      quizData: (json['quiz_data'] as List<dynamic>?)
          ?.map(
            (e) => e == null ? null : QuizDataBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      time: json['time'] as num,
      timeLeft: json['time_left'] as num,
      quizTime: json['quiz_time'],
    );

Map<String, dynamic> _$QuizResponseToJson(QuizResponse instance) => <String, dynamic>{
      'section': instance.section,
      'prev_lesson_type': instance.prevLessonType,
      'next_lesson_type': instance.nextLessonType,
      'prev_lesson': instance.prevLesson,
      'next_lesson': instance.nextLesson,
      'title': instance.title,
      'type': instance.type,
      'content': instance.content,
      'video': instance.video,
      'view_link': instance.viewLink,
      'quiz_data': instance.quizData,
      'time': instance.time,
      'time_left': instance.timeLeft,
      'quiz_time': instance.quizTime,
    };

QuizDataBean _$QuizDataBeanFromJson(Map<String, dynamic> json) => QuizDataBean(
      userQuizId: json['user_quiz_id'] as String,
      userId: json['user_id'] as String,
      courseId: json['course_id'] as String,
      quizId: json['quiz_id'] as String,
      progress: json['progress'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$QuizDataBeanToJson(QuizDataBean instance) => <String, dynamic>{
      'user_quiz_id': instance.userQuizId,
      'user_id': instance.userId,
      'course_id': instance.courseId,
      'quiz_id': instance.quizId,
      'progress': instance.progress,
      'status': instance.status,
    };

SectionBean _$SectionBeanFromJson(Map<String, dynamic> json) => SectionBean(
      label: json['label'] as String,
      number: json['number'] as String,
    );

Map<String, dynamic> _$SectionBeanToJson(SectionBean instance) => <String, dynamic>{
      'label': instance.label,
      'number': instance.number,
    };
