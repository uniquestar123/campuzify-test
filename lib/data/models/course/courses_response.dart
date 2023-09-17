import 'package:json_annotation/json_annotation.dart';
import 'package:masterstudy_app/data/models/category/category.dart';

part 'courses_response.g.dart';

@JsonSerializable()
class CoursesResponse {
  CoursesResponse({
    required this.page,
    required this.courses,
    required this.totalPages,
  });

  factory CoursesResponse.fromJson(Map<String, dynamic> json) => _$CoursesResponseFromJson(json);

  int? page;
  List<CoursesBean?> courses;
  @JsonKey(name: 'total_pages')
  int? totalPages;

  Map<String, dynamic> toJson() => _$CoursesResponseToJson(this);
}

@JsonSerializable()
class CoursesBean {
  CoursesBean({
    required this.id,
    required this.title,
    required this.images,
    required this.notSaleable,
    required this.categories,
    required this.price,
    required this.rating,
    required this.isFavorite,
    required this.featured,
    required this.status,
    required this.categoriesObject,
  });

  factory CoursesBean.fromJson(Map<String, dynamic> json) => _$CoursesBeanFromJson(json);

  int id;
  String? title;
  ImagesBean? images;
  @JsonKey(name: 'not_saleable')
  bool notSaleable;
  List<String?> categories;
  PriceBean? price;
  RatingBean? rating;
  @JsonKey(name: 'is_favorite')
  bool isFavorite;
  String? featured;
  StatusBean? status;
  @JsonKey(name: 'categories_object')
  List<Category?> categoriesObject;

  Map<String, dynamic> toJson() => _$CoursesBeanToJson(this);
}

@JsonSerializable()
class PriceBean {
  PriceBean({
    required this.free,
    this.price,
    this.oldPrice,
  });

  factory PriceBean.fromJson(Map<String, dynamic> json) => _$PriceBeanFromJson(json);

  final bool free;
  final String? price;
  @JsonKey(name: 'old_price')
  final String? oldPrice;

  Map<String, dynamic> toJson() => _$PriceBeanToJson(this);
}

@JsonSerializable()
class StatusBean {
  StatusBean({required this.status, required this.label});

  factory StatusBean.fromJson(Map<String, dynamic> json) => _$StatusBeanFromJson(json);

  String? status;
  String? label;

  Map<String, dynamic> toJson() => _$StatusBeanToJson(this);
}

@JsonSerializable()
class RatingBean {
  RatingBean({required this.average, required this.total, required this.percent});

  factory RatingBean.fromJson(Map<String, dynamic> json) => _$RatingBeanFromJson(json);

  num? average;
  num? total;
  num? percent;

  Map<String, dynamic> toJson() => _$RatingBeanToJson(this);
}

@JsonSerializable()
class ImagesBean {
  ImagesBean({required this.full, required this.small});

  factory ImagesBean.fromJson(Map<String, dynamic> json) => _$ImagesBeanFromJson(json);

  String? full;
  String? small;

  Map<String, dynamic> toJson() => _$ImagesBeanToJson(this);
}
