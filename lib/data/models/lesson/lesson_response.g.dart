// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonResponse _$LessonResponseFromJson(Map<String, dynamic> json) => LessonResponse(
      id: json['id'],
      section: json['section'] == null ? null : SectionBean.fromJson(json['section'] as Map<String, dynamic>),
      title: json['title'] as String?,
      type: json['type'] as String?,
      content: json['content'] as String?,
      videoType: $enumDecode(_$VideoTypeCodeEnumMap, json['video_type']),
      materials: (json['materials'] as List<dynamic>?)
          ?.map(
            (e) => e == null ? null : Materials.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      video: json['video'] as String?,
      videoPoster: json['video_poster'] as String?,
      prevLessonType: json['prev_lesson_type'] as String,
      nextLessonType: json['next_lesson_type'] as String,
      prevLesson: json['prev_lesson'] as int?,
      nextLesson: json['next_lesson'] as int?,
      completed: json['completed'] as bool,
      nextLessonAvailable: json['next_lesson_available'] as bool,
      viewLink: json['view_link'] as String?,
      quizData:
          (json['quiz_data'] as List<dynamic>?)?.map((e) => QuizDataBean.fromJson(e as Map<String, dynamic>)).toList(),
      time: json['time'] as num?,
      timeLeft: json['time_left'] as num?,
      quizTime: json['quiz_time'],
      fromCache: json['fromCache'] as bool?,
    );

Map<String, dynamic> _$LessonResponseToJson(LessonResponse instance) => <String, dynamic>{
      'id': instance.id,
      'section': instance.section,
      'title': instance.title,
      'type': instance.type,
      'content': instance.content,
      'video_type': _$VideoTypeCodeEnumMap[instance.videoType]!,
      'materials': instance.materials,
      'video': instance.video,
      'video_poster': instance.videoPoster,
      'prev_lesson_type': instance.prevLessonType,
      'next_lesson_type': instance.nextLessonType,
      'prev_lesson': instance.prevLesson,
      'next_lesson': instance.nextLesson,
      'completed': instance.completed,
      'next_lesson_available': instance.nextLessonAvailable,
      'view_link': instance.viewLink,
      'quiz_data': instance.quizData,
      'time': instance.time,
      'time_left': instance.timeLeft,
      'fromCache': instance.fromCache,
      'quiz_time': instance.quizTime,
    };

const _$VideoTypeCodeEnumMap = {
  VideoTypeCode.html: 'html',
  VideoTypeCode.youtube: 'youtube',
  VideoTypeCode.vimeo: 'vimeo',
  VideoTypeCode.ext_link: 'ext_link',
  VideoTypeCode.embed: 'embed',
  VideoTypeCode.shortcode: 'shortcode',
};

SectionBean _$SectionBeanFromJson(Map<String, dynamic> json) => SectionBean(
      label: json['label'],
      number: json['number'],
      index: json['index'],
    );

Map<String, dynamic> _$SectionBeanToJson(SectionBean instance) => <String, dynamic>{
      'label': instance.label,
      'number': instance.number,
      'index': instance.index,
    };

Materials _$MaterialsFromJson(Map<String, dynamic> json) => Materials(
      label: json['label'] as String,
      url: json['url'] as String,
      size: json['size'] as String,
      type: $enumDecode(_$MaterialsTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$MaterialsToJson(Materials instance) => <String, dynamic>{
      'label': instance.label,
      'url': instance.url,
      'size': instance.size,
      'type': _$MaterialsTypeEnumMap[instance.type]!,
    };

const _$MaterialsTypeEnumMap = {
  MaterialsType.audio: 'audio',
  MaterialsType.avi: 'avi',
  MaterialsType.doc: 'doc',
  MaterialsType.docx: 'docx',
  MaterialsType.gif: 'gif',
  MaterialsType.jpeg: 'jpeg',
  MaterialsType.jpg: 'jpg',
  MaterialsType.mov: 'mov',
  MaterialsType.mp3: 'mp3',
  MaterialsType.mp4: 'mp4',
  MaterialsType.pdf: 'pdf',
  MaterialsType.png: 'png',
  MaterialsType.ppt: 'ppt',
  MaterialsType.pptx: 'pptx',
  MaterialsType.psd: 'psd',
  MaterialsType.txt: 'txt',
  MaterialsType.xls: 'xls',
  MaterialsType.xlsx: 'xlsx',
  MaterialsType.zip: 'zip',
};
