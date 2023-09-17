// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignmentResponse _$AssignmentResponseFromJson(Map<String, dynamic> json) => AssignmentResponse(
      id: json['id'] as int?,
      label: json['label'] as String?,
      files: (json['files'] as List<dynamic>?)?.map((e) => FilesBean.fromJson(e as Map<String, dynamic>)).toList(),
      status: json['status'] as String,
      comment: json['comment'] as String?,
      translations: json['translations'] == null
          ? null
          : TranslationBean.fromJson(
              json['translations'] as Map<String, dynamic>,
            ),
      title: json['title'] as String,
      content: json['content'] as String,
      draftId: json['draft_id'] as int?,
      button: json['button'] as String?,
      section: json['section'] == null ? null : SectionBean.fromJson(json['section'] as Map<String, dynamic>),
      prevLessonType: json['prev_lesson_type'] as String,
      nextLessonType: json['next_lesson_type'] as String,
      prevLesson: json['prev_lesson'],
      nextLesson: json['next_lesson'],
    );

Map<String, dynamic> _$AssignmentResponseToJson(AssignmentResponse instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'comment': instance.comment,
      'label': instance.label,
      'files': instance.files,
      'translations': instance.translations,
      'title': instance.title,
      'content': instance.content,
      'draft_id': instance.draftId,
      'button': instance.button,
      'section': instance.section,
      'prev_lesson_type': instance.prevLessonType,
      'next_lesson_type': instance.nextLessonType,
      'prev_lesson': instance.prevLesson,
      'next_lesson': instance.nextLesson,
    };

SectionBean _$SectionBeanFromJson(Map<String, dynamic> json) => SectionBean(
      label: json['label'] as String,
      number: json['number'] as String,
      index: json['index'] as int,
    );

Map<String, dynamic> _$SectionBeanToJson(SectionBean instance) => <String, dynamic>{
      'label': instance.label,
      'number': instance.number,
      'index': instance.index,
    };

TranslationBean _$TranslationBeanFromJson(Map<String, dynamic> json) => TranslationBean(
      title: json['title'] as String,
      content: json['content'] as String,
      files: json['files'] as String,
    );

Map<String, dynamic> _$TranslationBeanToJson(TranslationBean instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'files': instance.files,
    };

FilesBean _$FilesBeanFromJson(Map<String, dynamic> json) => FilesBean(
      data: json['data'] == null ? null : FileBean.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FilesBeanToJson(FilesBean instance) => <String, dynamic>{
      'data': instance.data,
    };

FileBean _$FileBeanFromJson(Map<String, dynamic> json) => FileBean(
      name: json['name'] as String,
      id: json['id'] as num,
      status: json['status'] as String,
      error: json['error'] as bool,
      link: json['link'] as String,
    );

Map<String, dynamic> _$FileBeanToJson(FileBean instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'status': instance.status,
      'error': instance.error,
      'link': instance.link,
    };
