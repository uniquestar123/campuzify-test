// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestorePasswordResponse _$RestorePasswordResponseFromJson(
  Map<String, dynamic> json,
) =>
    RestorePasswordResponse(
      json['status'] as String,
      json['message'] as String,
    );

Map<String, dynamic> _$RestorePasswordResponseToJson(
  RestorePasswordResponse instance,
) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
