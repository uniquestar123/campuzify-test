import 'package:json_annotation/json_annotation.dart';

part 'instructors_response.g.dart';

@JsonSerializable()
class InstructorsResponse {
  InstructorsResponse({required this.page, required this.data, required this.totalPages});

  factory InstructorsResponse.fromJson(Map<String, dynamic> json) => _$InstructorsResponseFromJson(json);

  int page;
  List<InstructorBean?> data;
  @JsonKey(name: 'total_pages')
  int totalPages;

  Map<String, dynamic> toJson() => _$InstructorsResponseToJson(this);
}

@JsonSerializable()
class InstructorBean {
  InstructorBean({
    required this.id,
    required this.login,
    required this.avatar,
    required this.avatarUrl,
    required this.email,
    required this.url,
    required this.meta,
    required this.rating,
    required this.profileUrl,
  });

  factory InstructorBean.fromJson(Map<String, dynamic> json) => _$InstructorBeanFromJson(json);

  int id;
  String login;
  String avatar;
  @JsonKey(name: 'avatar_url')
  String avatarUrl;
  String email;
  String url;
  MetaBean? meta;
  RatingBean? rating;
  @JsonKey(name: 'profile_url')
  String profileUrl;

  Map<String, dynamic> toJson() => _$InstructorBeanToJson(this);
}

@JsonSerializable()
class RatingBean {
  RatingBean({
    required this.total,
    required this.average,
    required this.marksNum,
    required this.totalMarks,
    required this.percent,
  });

  factory RatingBean.fromJson(Map<String, dynamic> json) => _$RatingBeanFromJson(json);

  num total;
  num average;
  @JsonKey(name: 'marks_num')
  num marksNum;
  @JsonKey(name: 'total_marks')
  String totalMarks;
  num percent;

  Map<String, dynamic> toJson() => _$RatingBeanToJson(this);
}

@JsonSerializable()
class MetaBean {
  MetaBean({
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.googlePlus,
    required this.position,
    required this.description,
    required this.firstName,
    required this.lastName,
  });

  factory MetaBean.fromJson(Map<String, dynamic> json) => _$MetaBeanFromJson(json);

  String facebook;
  String twitter;
  String instagram;
  @JsonKey(name: 'google-plus')
  String googlePlus;
  String position;
  String description;
  @JsonKey(name: 'first_name')
  String firstName;
  @JsonKey(name: 'last_name')
  String lastName;

  Map<String, dynamic> toJson() => _$MetaBeanToJson(this);
}
