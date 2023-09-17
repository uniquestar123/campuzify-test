// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthErrorResponse _$AuthErrorResponseFromJson(Map<String, dynamic> json) =>
    AuthErrorResponse(
      code: json['code'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ErrorData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthErrorResponseToJson(AuthErrorResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

ErrorData _$ErrorDataFromJson(Map<String, dynamic> json) => ErrorData(
      status: json['status'] as int?,
      params:
          (json['params'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    );

Map<String, dynamic> _$ErrorDataToJson(ErrorData instance) => <String, dynamic>{
      'status': instance.status,
      'params': instance.params,
    };
