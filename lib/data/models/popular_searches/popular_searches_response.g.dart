// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_searches_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularSearchesResponse _$PopularSearchesResponseFromJson(
  Map<String, dynamic> json,
) =>
    PopularSearchesResponse(
      searches: (json['searches'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PopularSearchesResponseToJson(
  PopularSearchesResponse instance,
) =>
    <String, dynamic>{
      'searches': instance.searches,
    };
