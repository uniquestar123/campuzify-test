import 'package:json_annotation/json_annotation.dart';
import 'package:masterstudy_app/data/models/category/category.dart';

part 'course_detail_response.g.dart';

@JsonSerializable()
class CourseDetailResponse {
  CourseDetailResponse({
    required this.id,
    required this.title,
    this.images,
    required this.notSaleable,
    required this.categories,
    this.price,
    required this.rating,
    required this.featured,
    required this.status,
    required this.author,
    required this.url,
    required this.description,
    required this.meta,
    required this.announcement,
    required this.purchaseLabel,
    required this.curriculum,
    this.faq,
    required this.isFavorite,
    required this.trial,
    required this.firstLesson,
    required this.firstLessonType,
    required this.hasAccess,
    required this.categoriesObject,
    this.tokenAuth,
  });

  factory CourseDetailResponse.fromJson(Map<String, dynamic> json) => _$CourseDetailResponseFromJson(json);
  final int id;
  final String title;
  ImagesBean? images;
  @JsonKey(name: 'not_saleable')
  final bool notSaleable;
  List<String?> categories;
  PriceBean? price;
  RatingBean? rating;
  @JsonKey(name: 'is_favorite')
  bool? isFavorite;
  dynamic featured;
  dynamic status;
  @JsonKey(name: 'categories_object')
  List<Category?> categoriesObject;
  AuthorBean? author;
  String? url;
  String? description;
  List<MetaBean?> meta;
  String? announcement;
  @JsonKey(name: 'purchase_label')
  String? purchaseLabel;
  List<CurriculumBean?>? curriculum;
  List<FaqBean?>? faq;
  bool trial;
  @JsonKey(name: 'first_lesson')
  dynamic firstLesson;
  @JsonKey(name: 'first_lesson_type')
  String? firstLessonType;
  @JsonKey(name: 'has_access')
  bool? hasAccess;
  @JsonKey(name: 'token_auth')
  dynamic tokenAuth;

  Map<String, dynamic> toJson() => _$CourseDetailResponseToJson(this);
}

@JsonSerializable()
class FaqBean {
  FaqBean({required this.question, required this.answer});

  factory FaqBean.fromJson(Map<String, dynamic> json) => _$FaqBeanFromJson(json);
  String? question;
  String? answer;

  Map<String, dynamic> toJson() => _$FaqBeanToJson(this);
}

@JsonSerializable()
class CurriculumBean {
  CurriculumBean({
    required this.type,
    required this.view,
    required this.label,
    required this.meta,
    this.lessonId,
    this.hasPreview,
  });

  factory CurriculumBean.fromJson(Map<String, dynamic> json) => _$CurriculumBeanFromJson(json);

  String? type;
  String? view;
  String? label;
  String? meta;
  @JsonKey(name: 'lesson_id')
  dynamic lessonId;
  @JsonKey(name: 'has_preview')
  dynamic hasPreview;

  Map<String, dynamic> toJson() => _$CurriculumBeanToJson(this);
}

@JsonSerializable()
class MetaBean {
  MetaBean({required this.type, required this.label, required this.text});

  factory MetaBean.fromJson(Map<String, dynamic> json) => _$MetaBeanFromJson(json);

  String type;
  String label;
  String? text;

  Map<String, dynamic> toJson() => _$MetaBeanToJson(this);
}

@JsonSerializable()
class AuthorBean {
  AuthorBean({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.url,
    required this.meta,
    required this.rating,
  });

  factory AuthorBean.fromJson(Map<String, dynamic> json) => _$AuthorBeanFromJson(json);

  num? id;
  String login;
  @JsonKey(name: 'avatar_url')
  String? avatarUrl;
  String? url;
  AuthorMetaBean? meta;
  AuthorRatingBean? rating;

  Map<String, dynamic> toJson() => _$AuthorBeanToJson(this);
}

@JsonSerializable()
class AuthorMetaBean {
  AuthorMetaBean({
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.googlePlus,
    required this.position,
    required this.description,
    required this.firstName,
    required this.lastName,
  });

  factory AuthorMetaBean.fromJson(Map<String, dynamic> json) => _$AuthorMetaBeanFromJson(json);

  String? facebook;
  String? twitter;
  String? instagram;
  @JsonKey(name: 'google-plus')
  String? googlePlus;
  String? position;
  String? description;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'last_name')
  String? lastName;

  Map<String, dynamic> toJson() => _$AuthorMetaBeanToJson(this);
}

@JsonSerializable()
class AuthorRatingBean {
  AuthorRatingBean({
    required this.total,
    required this.average,
    required this.marksNum,
    required this.totalMarks,
    required this.percent,
  });

  factory AuthorRatingBean.fromJson(Map<String, dynamic> json) => _$AuthorRatingBeanFromJson(json);

  num? total;
  num? average;
  @JsonKey(name: 'marks_num')
  num? marksNum;
  @JsonKey(name: 'total_marks')
  String? totalMarks;
  num? percent;

  Map<String, dynamic> toJson() => _$AuthorRatingBeanToJson(this);
}

@JsonSerializable()
class RatingBean {
  RatingBean({
    required this.total,
    required this.average,
    required this.percent,
    required this.details,
  });

  factory RatingBean.fromJson(Map<String, dynamic> json) => _$RatingBeanFromJson(json);

  num? average;
  int total;
  num? percent;
  DetailsBean? details;

  Map<String, dynamic> toJson() => _$RatingBeanToJson(this);
}

@JsonSerializable()
class DetailsBean {
  DetailsBean({
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
  });

  factory DetailsBean.fromJson(Map<String, dynamic> json) => _$DetailsBeanFromJson(json);

  @JsonKey(name: '1')
  num one;
  @JsonKey(name: '2')
  num two;
  @JsonKey(name: '3')
  num three;
  @JsonKey(name: '4')
  num four;
  @JsonKey(name: '5')
  num five;

  Map<String, dynamic> toJson() => _$DetailsBeanToJson(this);
}

@JsonSerializable()
class PriceBean {
  PriceBean({required this.free, required this.price, this.oldPrice});

  factory PriceBean.fromJson(Map<String, dynamic> json) => _$PriceBeanFromJson(json);

  bool? free;
  String? price;
  @JsonKey(name: 'old_price')
  String? oldPrice;

  Map<String, dynamic> toJson() => _$PriceBeanToJson(this);
}

@JsonSerializable()
class ImagesBean {
  ImagesBean({this.full, required this.small});

  factory ImagesBean.fromJson(Map<String, dynamic> json) => _$ImagesBeanFromJson(json);

  String? full;
  String? small;

  Map<String, dynamic> toJson() => _$ImagesBeanToJson(this);
}

@JsonSerializable()
class TokenAuthToCourse {
  TokenAuthToCourse({this.tokenAuth});

  factory TokenAuthToCourse.fromJson(Map<String, dynamic> json) => _$TokenAuthToCourseFromJson(json);

  @JsonKey(name: 'token_auth')
  String? tokenAuth;

  Map<String, dynamic> toJson() => _$TokenAuthToCourseToJson(this);
}
