import 'package:json_annotation/json_annotation.dart';

part 'restore_password.g.dart';

@JsonSerializable()
class RestorePasswordResponse {
  factory RestorePasswordResponse.fromJson(Map<String, dynamic> json) => _$RestorePasswordResponseFromJson(json);

  RestorePasswordResponse(this.status, this.message);

  final String status;
  final String message;

  Map<String, dynamic> toJson() => _$RestorePasswordResponseToJson(this);
}
