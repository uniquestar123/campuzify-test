// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionsResponse _$QuestionsResponseFromJson(Map<String, dynamic> json) => QuestionsResponse(
      posts: (json['posts'] as List<dynamic>)
          .map(
            (e) => e == null ? null : QuestionBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$QuestionsResponseToJson(QuestionsResponse instance) => <String, dynamic>{
      'posts': instance.posts,
    };

QuestionBean _$QuestionBeanFromJson(Map<String, dynamic> json) => QuestionBean(
      commentId: json['comment_ID'] as String?,
      content: json['content'] as String?,
      author: json['author'] == null ? null : QuestionAuthorBean.fromJson(json['author'] as Map<String, dynamic>),
      dateTime: json['datetime'] as String?,
      repliesCount: json['replies_count'] as String?,
      replies: (json['replies'] as List<dynamic>)
          .map(
            (e) => e == null ? null : ReplyBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$QuestionBeanToJson(QuestionBean instance) => <String, dynamic>{
      'comment_ID': instance.commentId,
      'content': instance.content,
      'author': instance.author,
      'datetime': instance.dateTime,
      'replies_count': instance.repliesCount,
      'replies': instance.replies,
    };

QuestionAuthorBean _$QuestionAuthorBeanFromJson(Map<String, dynamic> json) => QuestionAuthorBean(
      id: json['id'] as int,
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String?,
      url: json['url'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$QuestionAuthorBeanToJson(QuestionAuthorBean instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'avatar_url': instance.avatarUrl,
      'email': instance.email,
      'url': instance.url,
    };

ReplyBean _$ReplyBeanFromJson(Map<String, dynamic> json) => ReplyBean(
      commentId: json['comment_ID'] as String,
      content: json['content'] as String,
      author: json['author'] == null ? null : QuestionAuthorBean.fromJson(json['author'] as Map<String, dynamic>),
      datetime: json['datetime'] as String,
    );

Map<String, dynamic> _$ReplyBeanToJson(ReplyBean instance) => <String, dynamic>{
      'comment_ID': instance.commentId,
      'content': instance.content,
      'author': instance.author,
      'datetime': instance.datetime,
    };
