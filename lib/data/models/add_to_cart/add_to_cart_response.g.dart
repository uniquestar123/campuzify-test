// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToCartResponse _$AddToCartResponseFromJson(Map<String, dynamic> json) =>
    AddToCartResponse(
      added: json['added'] as String,
      text: json['text'] as String,
      cartUrl: json['cart_url'] as String,
      redirect: json['redirect'] as bool,
      lessonId: json['lesson_id'] as int?,
    );

Map<String, dynamic> _$AddToCartResponseToJson(AddToCartResponse instance) =>
    <String, dynamic>{
      'added': instance.added,
      'text': instance.text,
      'cart_url': instance.cartUrl,
      'redirect': instance.redirect,
      'lesson_id': instance.lessonId,
    };
