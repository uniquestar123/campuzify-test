import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable()
class AuthResponse {
  AuthResponse(this.token);

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);

  String token;

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
