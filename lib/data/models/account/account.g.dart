// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['id'] as int?,
      login: json['login'] as String?,
      avatar: json['avatar'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      email: json['email'] as String?,
      url: json['url'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      meta: json['meta'] == null
          ? null
          : MetaBean.fromJson(json['meta'] as Map<String, dynamic>),
      rating: json['rating'] == null
          ? null
          : RatingBean.fromJson(json['rating'] as Map<String, dynamic>),
      profileUrl: json['profile_url'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'avatar': instance.avatar,
      'avatar_url': instance.avatarUrl,
      'email': instance.email,
      'url': instance.url,
      'roles': instance.roles,
      'meta': instance.meta,
      'rating': instance.rating,
      'profile_url': instance.profileUrl,
    };

RatingBean _$RatingBeanFromJson(Map<String, dynamic> json) => RatingBean(
      total: json['total'] as num?,
      average: json['average'] as num?,
      marksNum: json['marks_num'] as num?,
      totalMarks: json['total_marks'] as String?,
      percent: json['percent'] as num?,
    );

Map<String, dynamic> _$RatingBeanToJson(RatingBean instance) =>
    <String, dynamic>{
      'total': instance.total,
      'average': instance.average,
      'marks_num': instance.marksNum,
      'total_marks': instance.totalMarks,
      'percent': instance.percent,
    };
