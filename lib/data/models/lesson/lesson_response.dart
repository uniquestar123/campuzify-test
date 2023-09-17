import 'package:json_annotation/json_annotation.dart';
import 'package:masterstudy_app/data/models/quiz/quiz_response.dart';

part 'lesson_response.g.dart';

@JsonSerializable()
class LessonResponse {
  LessonResponse({
    this.id,
    required this.section,
    required this.title,
    required this.type,
    required this.content,
    required this.videoType,
    required this.materials,
    required this.video,
    required this.videoPoster,
    required this.prevLessonType,
    required this.nextLessonType,
    required this.prevLesson,
    required this.nextLesson,
    required this.completed,
    required this.nextLessonAvailable,
    required this.viewLink,
    required this.quizData,
    required this.time,
    required this.timeLeft,
    this.quizTime,
    required this.fromCache,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) => _$LessonResponseFromJson(json);

  dynamic id;
  SectionBean? section;
  String? title;
  String? type;
  String? content;
  @JsonKey(name: 'video_type')
  VideoTypeCode videoType;
  List<Materials?>? materials;
  String? video;
  @JsonKey(name: 'video_poster')
  String? videoPoster;
  @JsonKey(name: 'prev_lesson_type')
  String prevLessonType;
  @JsonKey(name: 'next_lesson_type')
  String nextLessonType;
  @JsonKey(name: 'prev_lesson')
  int? prevLesson;
  @JsonKey(name: 'next_lesson')
  int? nextLesson;
  bool completed;
  @JsonKey(name: 'next_lesson_available')
  bool nextLessonAvailable;
  @JsonKey(name: 'view_link')
  String? viewLink;
  @JsonKey(name: 'quiz_data')
  List<QuizDataBean>? quizData;
  num? time;
  @JsonKey(name: 'time_left')
  num? timeLeft;
  bool? fromCache;
  @JsonKey(name: 'quiz_time')
  dynamic quizTime;

  Map<String, dynamic> toJson() => _$LessonResponseToJson(this);
}

@JsonSerializable()
class SectionBean {
  SectionBean({this.label, this.number, this.index});

  factory SectionBean.fromJson(Map<String, dynamic> json) => _$SectionBeanFromJson(json);
  final dynamic label;
  final dynamic number;
  final dynamic index;

  Map<String, dynamic> toJson() => _$SectionBeanToJson(this);
}

@JsonSerializable()
class Materials {
  Materials({
    required this.label,
    required this.url,
    required this.size,
    required this.type,
  });

  factory Materials.fromJson(Map<String, dynamic> json) => _$MaterialsFromJson(json);

  final String label;
  final String url;
  final String size;
  final MaterialsType type;

  Map<String, dynamic> toJson() => _$MaterialsToJson(this);
}

enum VideoTypeCode { html, youtube, vimeo, ext_link, embed, shortcode }

enum MaterialsType {
  audio,
  avi,
  doc,
  docx,
  gif,
  jpeg,
  jpg,
  mov,
  mp3,
  mp4,
  pdf,
  png,
  ppt,
  pptx,
  psd,
  txt,
  xls,
  xlsx,
  zip,
}
