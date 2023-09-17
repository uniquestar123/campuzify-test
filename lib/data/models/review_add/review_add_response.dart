import 'package:json_annotation/json_annotation.dart';

part 'review_add_response.g.dart';

@JsonSerializable()
class ReviewAddResponse {
  ReviewAddResponse({required this.error, required this.status, required this.message});

  factory ReviewAddResponse.fromJson(Map<String, dynamic> json) => _$ReviewAddResponseFromJson(json);

  bool error;
  String status;
  String message;

  Map<String, dynamic> toJson() => _$ReviewAddResponseToJson(this);
}
