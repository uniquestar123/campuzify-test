// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructors_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorsResponse _$InstructorsResponseFromJson(Map<String, dynamic> json) => InstructorsResponse(
      page: json['page'] as int,
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => e == null ? null : InstructorBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      totalPages: json['total_pages'] as int,
    );

Map<String, dynamic> _$InstructorsResponseToJson(
  InstructorsResponse instance,
) =>
    <String, dynamic>{
      'page': instance.page,
      'data': instance.data,
      'total_pages': instance.totalPages,
    };

InstructorBean _$InstructorBeanFromJson(Map<String, dynamic> json) => InstructorBean(
      id: json['id'] as int,
      login: json['login'] as String,
      avatar: json['avatar'] as String,
      avatarUrl: json['avatar_url'] as String,
      email: json['email'] as String,
      url: json['url'] as String,
      meta: json['meta'] == null ? null : MetaBean.fromJson(json['meta'] as Map<String, dynamic>),
      rating: json['rating'] == null ? null : RatingBean.fromJson(json['rating'] as Map<String, dynamic>),
      profileUrl: json['profile_url'] as String,
    );

Map<String, dynamic> _$InstructorBeanToJson(InstructorBean instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'avatar': instance.avatar,
      'avatar_url': instance.avatarUrl,
      'email': instance.email,
      'url': instance.url,
      'meta': instance.meta,
      'rating': instance.rating,
      'profile_url': instance.profileUrl,
    };

RatingBean _$RatingBeanFromJson(Map<String, dynamic> json) => RatingBean(
      total: json['total'] as num,
      average: json['average'] as num,
      marksNum: json['marks_num'] as num,
      totalMarks: json['total_marks'] as String,
      percent: json['percent'] as num,
    );

Map<String, dynamic> _$RatingBeanToJson(RatingBean instance) => <String, dynamic>{
      'total': instance.total,
      'average': instance.average,
      'marks_num': instance.marksNum,
      'total_marks': instance.totalMarks,
      'percent': instance.percent,
    };

MetaBean _$MetaBeanFromJson(Map<String, dynamic> json) => MetaBean(
      facebook: json['facebook'] as String,
      twitter: json['twitter'] as String,
      instagram: json['instagram'] as String,
      googlePlus: json['google-plus'] as String,
      position: json['position'] as String,
      description: json['description'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
    );

Map<String, dynamic> _$MetaBeanToJson(MetaBean instance) => <String, dynamic>{
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'instagram': instance.instagram,
      'google-plus': instance.googlePlus,
      'position': instance.position,
      'description': instance.description,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };
