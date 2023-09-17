import 'package:json_annotation/json_annotation.dart';

part 'quiz_response.g.dart';

@JsonSerializable()
class QuizResponse {
  QuizResponse({
    required this.section,
    required this.title,
    required this.type,
    required this.content,
    required this.video,
    required this.prevLessonType,
    required this.nextLessonType,
    required this.prevLesson,
    required this.nextLesson,
    required this.viewLink,
    required this.quizData,
    required this.time,
    required this.timeLeft,
    this.quizTime,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) => _$QuizResponseFromJson(json);

  SectionBean? section;
  @JsonKey(name: 'prev_lesson_type')
  String prevLessonType;
  @JsonKey(name: 'next_lesson_type')
  String nextLessonType;
  @JsonKey(name: 'prev_lesson')
  int? prevLesson;
  @JsonKey(name: 'next_lesson')
  int? nextLesson;
  String title;
  String type;
  String content;
  String video;
  @JsonKey(name: 'view_link')
  String viewLink;
  @JsonKey(name: 'quiz_data')
  List<QuizDataBean?>? quizData;
  num time;
  @JsonKey(name: 'time_left')
  num timeLeft;
  @JsonKey(name: 'quiz_time')
  dynamic quizTime;

  Map<String, dynamic> toJson() => _$QuizResponseToJson(this);
}

@JsonSerializable()
class QuizDataBean {
  QuizDataBean({
    required this.userQuizId,
    required this.userId,
    required this.courseId,
    required this.quizId,
    required this.progress,
    required this.status,
  });

  factory QuizDataBean.fromJson(Map<String, dynamic> json) => _$QuizDataBeanFromJson(json);

  @JsonKey(name: 'user_quiz_id')
  String userQuizId;
  @JsonKey(name: 'user_id')
  String userId;
  @JsonKey(name: 'course_id')
  String courseId;
  @JsonKey(name: 'quiz_id')
  String quizId;
  String progress;
  String status;

  Map<String, dynamic> toJson() => _$QuizDataBeanToJson(this);
}

@JsonSerializable()
class SectionBean {
  SectionBean({required this.label, required this.number});

  factory SectionBean.fromJson(Map<String, dynamic> json) => _$SectionBeanFromJson(json);

  String label;
  String number;

  Map<String, dynamic> toJson() => _$SectionBeanToJson(this);
}
