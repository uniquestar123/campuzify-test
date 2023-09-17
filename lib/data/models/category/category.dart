import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  Category({
    required this.id,
    required this.name,
    required this.count,
    this.color,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  int id;
  String name;
  int count;
  String? color;
  String? image;

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
