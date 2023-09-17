import 'package:json_annotation/json_annotation.dart';

part 'review_response.g.dart';

@JsonSerializable()
class ReviewResponse {
  ReviewResponse({required this.posts, required this.total});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => _$ReviewResponseFromJson(json);

  List<ReviewBean?> posts;
  bool total;

  Map<String, dynamic> toJson() => _$ReviewResponseToJson(this);
}

@JsonSerializable()
class ReviewBean {
  ReviewBean({
    required this.user,
    required this.avatarUrl,
    required this.time,
    required this.title,
    required this.content,
    required this.mark,
  });

  factory ReviewBean.fromJson(Map<String, dynamic> json) => _$ReviewBeanFromJson(json);

  String user;
  @JsonKey(name: 'avatar_url')
  String avatarUrl;
  String time;
  String title;
  String content;
  num mark;

  Map<String, dynamic> toJson() => _$ReviewBeanToJson(this);
}
