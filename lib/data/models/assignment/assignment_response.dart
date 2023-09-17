import 'package:json_annotation/json_annotation.dart';

part 'assignment_response.g.dart';

@JsonSerializable()
class AssignmentResponse {
  AssignmentResponse({
    this.id,
    this.label,
    this.files,
    required this.status,
    this.comment,
    this.translations,
    required this.title,
    required this.content,
    this.draftId,
    required this.button,
    required this.section,
    required this.prevLessonType,
    required this.nextLessonType,
    required this.prevLesson,
    required this.nextLesson,
  });

  factory AssignmentResponse.fromJson(Map<String, dynamic> json) => _$AssignmentResponseFromJson(json);

  /// Переменная [id] появлвяется в том случае только если [status] == [pending]
  final int? id;
  final String status;

  /// Переменная [comment] появлвяется в том случае только если [status] == [passed]
  final String? comment;

  /// Переменная [label] появлвяется в том случае только если [status] == [pending]
  final String? label;

  /// Переменная [files] появлвяется в том случае только если [status] == [pending]
  final List<FilesBean>? files;

  /// Переменная [translations] появляется в том случае только если [status] == [draft]
  final TranslationBean? translations;
  final String title;
  final String content;
  @JsonKey(name: 'draft_id')

  /// Переменная [draftId] появляется в том случае только если [status] == [draft]
  final int? draftId;
  final String? button;
  final SectionBean? section;
  @JsonKey(name: 'prev_lesson_type')
  final String prevLessonType;
  @JsonKey(name: 'next_lesson_type')
  final String nextLessonType;
  @JsonKey(name: 'prev_lesson')
  final dynamic prevLesson;
  @JsonKey(name: 'next_lesson')
  final dynamic nextLesson;

  Map<String, dynamic> toJson() => _$AssignmentResponseToJson(this);
}

@JsonSerializable()
class SectionBean {
  SectionBean({required this.label, required this.number, required this.index});

  factory SectionBean.fromJson(Map<String, dynamic> json) => _$SectionBeanFromJson(json);

  final String label;
  final String number;
  final int index;

  Map<String, dynamic> toJson() => _$SectionBeanToJson(this);
}

@JsonSerializable()
class TranslationBean {
  TranslationBean({required this.title, required this.content, required this.files});

  factory TranslationBean.fromJson(Map<String, dynamic> json) => _$TranslationBeanFromJson(json);

  final String title;
  final String content;
  final String files;

  Map<String, dynamic> toJson() => _$TranslationBeanToJson(this);
}

@JsonSerializable()
class FilesBean {
  FilesBean({required this.data});

  factory FilesBean.fromJson(Map<String, dynamic> json) => _$FilesBeanFromJson(json);
  FileBean? data;

  Map<String, dynamic> toJson() => _$FilesBeanToJson(this);
}

@JsonSerializable()
class FileBean {
  FileBean({
    required this.name,
    required this.id,
    required this.status,
    required this.error,
    required this.link,
  });

  factory FileBean.fromJson(Map<String, dynamic> json) => _$FileBeanFromJson(json);
  String name;
  num id;
  String status;
  bool error;
  String link;

  Map<String, dynamic> toJson() => _$FileBeanToJson(this);
}
