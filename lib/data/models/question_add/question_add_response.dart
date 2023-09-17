import 'package:json_annotation/json_annotation.dart';

part 'question_add_response.g.dart';

@JsonSerializable()
class QuestionAddResponse {
  QuestionAddResponse({
    required this.error,
    required this.status,
    required this.message,
    required this.comment,
  });

  factory QuestionAddResponse.fromJson(Map<String, dynamic> json) => _$QuestionAddResponseFromJson(json);

  bool error;
  String status;
  String message;
  QuestionAddBean? comment;

  Map<String, dynamic> toJson() => _$QuestionAddResponseToJson(this);
}

@JsonSerializable()
class QuestionAddBean {
  QuestionAddBean({
    required this.commentId,
    required this.content,
    required this.author,
    required this.datetime,
    required this.repliesCount,
  });

  factory QuestionAddBean.fromJson(Map<String, dynamic> json) => _$QuestionAddBeanFromJson(json);

  @JsonKey(name:'comment_ID')
  String commentId;
  String content;
  QuestionAddAuthorBean? author;
  String datetime;
  @JsonKey(name:'replies_count')
  String repliesCount;

  Map<String, dynamic> toJson() => _$QuestionAddBeanToJson(this);
}

@JsonSerializable()
class QuestionAddAuthorBean {
  QuestionAddAuthorBean({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.url,
    required this.email,
  });

  factory QuestionAddAuthorBean.fromJson(Map<String, dynamic> json) => _$QuestionAddAuthorBeanFromJson(json);

  int id;
  String login;
  @JsonKey(name:'avatar_url')
  String avatarUrl;
  String url;
  String email;

  Map<String, dynamic> toJson() => _$QuestionAddAuthorBeanToJson(this);
}

@JsonSerializable()
class ReplyAddBean {
  ReplyAddBean({
    required this.commentId,
    required this.content,
    required this.author,
    required this.datetime,
  });

  factory ReplyAddBean.fromJson(Map<String, dynamic> json) => _$ReplyAddBeanFromJson(json);

  @JsonKey(name:'comment_ID')
  String commentId;
  String content;
  QuestionAddAuthorBean? author;
  String datetime;

  Map<String, dynamic> toJson() => _$ReplyAddBeanToJson(this);
}
