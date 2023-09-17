// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewResponse _$ReviewResponseFromJson(Map<String, dynamic> json) => ReviewResponse(
      posts: (json['posts'] as List<dynamic>)
          .map(
            (e) => e == null ? null : ReviewBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      total: json['total'] as bool,
    );

Map<String, dynamic> _$ReviewResponseToJson(ReviewResponse instance) => <String, dynamic>{
      'posts': instance.posts,
      'total': instance.total,
    };

ReviewBean _$ReviewBeanFromJson(Map<String, dynamic> json) => ReviewBean(
      user: json['user'] as String,
      avatarUrl: json['avatar_url'] as String,
      time: json['time'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      mark: json['mark'] as num,
    );

Map<String, dynamic> _$ReviewBeanToJson(ReviewBean instance) => <String, dynamic>{
      'user': instance.user,
      'avatar_url': instance.avatarUrl,
      'time': instance.time,
      'title': instance.title,
      'content': instance.content,
      'mark': instance.mark,
    };
