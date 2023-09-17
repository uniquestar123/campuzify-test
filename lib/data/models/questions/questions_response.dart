import 'package:json_annotation/json_annotation.dart';

part 'questions_response.g.dart';

@JsonSerializable()
class QuestionsResponse {
  QuestionsResponse({required this.posts});

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) => _$QuestionsResponseFromJson(json);

  List<QuestionBean?> posts;

  Map<String, dynamic> toJson() => _$QuestionsResponseToJson(this);
}

@JsonSerializable()
class QuestionBean {
  QuestionBean({
    required this.commentId,
    required this.content,
    required this.author,
    required this.dateTime,
    required this.repliesCount,
    required this.replies,
  });

  factory QuestionBean.fromJson(Map<String, dynamic> json) => _$QuestionBeanFromJson(json);

  @JsonKey(name: 'comment_ID')
  String? commentId;
  String? content;
  QuestionAuthorBean? author;
  @JsonKey(name: 'datetime')
  String? dateTime;
  @JsonKey(name: 'replies_count')
  String? repliesCount;
  List<ReplyBean?> replies;

  Map<String, dynamic> toJson() => _$QuestionBeanToJson(this);
}

@JsonSerializable()
class QuestionAuthorBean {
  QuestionAuthorBean({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.url,
    required this.email,
  });

  factory QuestionAuthorBean.fromJson(Map<String, dynamic> json) => _$QuestionAuthorBeanFromJson(json);

  int id;
  String login;
  @JsonKey(name: 'avatar_url')
  String? avatarUrl;
  String? email;
  String? url;

  Map<String, dynamic> toJson() => _$QuestionAuthorBeanToJson(this);
}

@JsonSerializable()
class ReplyBean {
  ReplyBean({
    required this.commentId,
    required this.content,
    required this.author,
    required this.datetime,
  });

  factory ReplyBean.fromJson(Map<String, dynamic> json) => _$ReplyBeanFromJson(json);
  @JsonKey(name: 'comment_ID')
  String commentId;
  String content;
  QuestionAuthorBean? author;
  String datetime;

  Map<String, dynamic> toJson() => _$ReplyBeanToJson(this);
}
