import 'package:json_annotation/json_annotation.dart';
import 'package:masterstudy_app/data/models/instructors/instructors_response.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  Account({
    this.id,
    this.login,
    this.avatar,
    this.avatarUrl,
    this.email,
    this.url,
    this.roles,
    this.meta,
    this.rating,
    this.profileUrl,
  });

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  int? id;
  String? login;
  String? avatar;
  @JsonKey(name: 'avatar_url')
  String? avatarUrl;
  String? email;
  String? url;
  List<String>? roles;
  MetaBean? meta;
  RatingBean? rating;
  @JsonKey(name: 'profile_url')
  String? profileUrl;

  Map<String, dynamic> toJson() => _$AccountToJson(this);
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

  num? total;
  num? average;
  @JsonKey(name: 'marks_num')
  num? marksNum;
  @JsonKey(name: 'total_marks')
  String? totalMarks;
  num? percent;

  Map<String, dynamic> toJson() => _$RatingBeanToJson(this);
}
