import 'package:json_annotation/json_annotation.dart';

part 'add_to_cart_response.g.dart';

@JsonSerializable()
class AddToCartResponse {
  AddToCartResponse({
    required this.added,
    required this.text,
    required this.cartUrl,
    required this.redirect,
    required this.lessonId,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) => _$AddToCartResponseFromJson(json);

  String added;
  String text;
  @JsonKey(name: 'cart_url')
  String cartUrl;
  bool redirect;
  @JsonKey(name: 'lesson_id')
  int? lessonId;

  Map<String, dynamic> toJson() => _$AddToCartResponseToJson(this);
}
