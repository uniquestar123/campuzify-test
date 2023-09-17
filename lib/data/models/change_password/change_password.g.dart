// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordResponse _$ChangePasswordResponseFromJson(
  Map<String, dynamic> json,
) =>
    ChangePasswordResponse(
      modified: Modified.fromJson(json['modified'] as Map<String, dynamic>),
      values: json['values'],
    );

Map<String, dynamic> _$ChangePasswordResponseToJson(
  ChangePasswordResponse instance,
) =>
    <String, dynamic>{
      'modified': instance.modified,
      'values': instance.values,
    };

Modified _$ModifiedFromJson(Map<String, dynamic> json) => Modified(
      json['new_password'] as bool,
    );

Map<String, dynamic> _$ModifiedToJson(Modified instance) => <String, dynamic>{
      'new_password': instance.newPassword,
    };
