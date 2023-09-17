import 'package:json_annotation/json_annotation.dart';

part 'change_password.g.dart';

@JsonSerializable()
class ChangePasswordResponse {
  ChangePasswordResponse({required this.modified, required this.values});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => _$ChangePasswordResponseFromJson(json);

  final Modified modified;

  // TODO: 27.06.2023 Find out the exact type of a variable
  final dynamic values;

  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}

@JsonSerializable()
class Modified {
  Modified(this.newPassword);

  factory Modified.fromJson(Map<String, dynamic> json) => _$ModifiedFromJson(json);

  @JsonKey(name: 'new_password')
  final bool newPassword;

  Map<String, dynamic> toJson() => _$ModifiedToJson(this);
}
