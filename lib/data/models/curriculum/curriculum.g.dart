// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curriculum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurriculumResponse _$CurriculumResponseFromJson(Map<String, dynamic> json) => CurriculumResponse(
      currentLessonId: json['current_lesson_id'] as String?,
      progressPercent: json['progress_percent'] as String,
      lessonType: json['lesson_type'] as String?,
      sections: (json['sections'] as List<dynamic>)
          .map(
            (e) => e == null ? null : SectionItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      materials:
          (json['materials'] as List<dynamic>).map((e) => MaterialItem.fromJson(e as Map<String, dynamic>)).toList(),
      scorm: json['scorm'],
    );

Map<String, dynamic> _$CurriculumResponseToJson(CurriculumResponse instance) => <String, dynamic>{
      'current_lesson_id': instance.currentLessonId,
      'progress_percent': instance.progressPercent,
      'lesson_type': instance.lessonType,
      'sections': instance.sections,
      'materials': instance.materials,
      'scorm': instance.scorm,
    };

SectionItem _$SectionItemFromJson(Map<String, dynamic> json) => SectionItem(
      id: json['id'] as int,
      title: json['title'] as String?,
      order: json['order'] as int,
      sectionItems: (json['sectionItems'] as List<dynamic>?)
          ?.map((e) => SectionItemsBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SectionItemToJson(SectionItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'order': instance.order,
      'sectionItems': instance.sectionItems,
    };

MaterialItem _$MaterialItemFromJson(Map<String, dynamic> json) => MaterialItem(
      id: json['id'] as int,
      title: json['title'] as String,
      postId: json['post_id'] as int,
      postType: json['post_type'] as String,
      lessonType: json['lesson_type'] as String?,
      sectionId: json['section_id'] as int,
      order: json['order'] as int,
      type: json['type'] as String,
      quizInfo: json['quiz_info'],
      locked: json['locked'] as bool,
      completed: json['completed'] as bool,
      hasPreview: json['has_preview'] as bool,
      duration: json['duration'],
      questions: json['questions'],
    );

Map<String, dynamic> _$MaterialItemToJson(MaterialItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'post_id': instance.postId,
      'post_type': instance.postType,
      'lesson_type': instance.lessonType,
      'section_id': instance.sectionId,
      'order': instance.order,
      'type': instance.type,
      'quiz_info': instance.quizInfo,
      'locked': instance.locked,
      'completed': instance.completed,
      'has_preview': instance.hasPreview,
      'duration': instance.duration,
      'questions': instance.questions,
    };

SectionItemsBean _$SectionItemsBeanFromJson(Map<String, dynamic> json) => SectionItemsBean(
      itemId: json['item_id'] as int?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      quizInfo: json['quiz_info'],
      locked: json['locked'] as bool?,
      completed: json['completed'] as bool?,
      hasPreview: json['has_preview'] as bool?,
      lessonId: json['lessonId'],
    )
      ..duration = json['duration'] as String?
      ..questions = json['questions'] as String?;

Map<String, dynamic> _$SectionItemsBeanToJson(SectionItemsBean instance) => <String, dynamic>{
      'item_id': instance.itemId,
      'title': instance.title,
      'type': instance.type,
      'quiz_info': instance.quizInfo,
      'locked': instance.locked,
      'completed': instance.completed,
      'lessonId': instance.lessonId,
      'has_preview': instance.hasPreview,
      'duration': instance.duration,
      'questions': instance.questions,
    };
