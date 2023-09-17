import 'package:json_annotation/json_annotation.dart';
import 'package:masterstudy_app/data/models/category/category.dart';

part 'user_course.g.dart';

@JsonSerializable()
class UserCourseResponse {
  UserCourseResponse({
    required this.posts,
    required this.total,
    required this.offset,
    required this.totalPosts,
    required this.pages,
  });

  factory UserCourseResponse.fromJson(Map<String, dynamic> json) => _$UserCourseResponseFromJson(json);

  List<PostsBean?> posts;
  String? total;
  num offset;
  @JsonKey(name: 'total_posts')
  num totalPosts;
  num pages;

  Map<String, dynamic> toJson() => _$UserCourseResponseToJson(this);
}

@JsonSerializable()
class PostsBean {
  PostsBean({
    required this.imageId,
    required this.title,
    required this.link,
    required this.image,
    required this.terms,
    required this.termsList,
    required this.views,
    required this.price,
    required this.salePrice,
    required this.postStatus,
    required this.progress,
    required this.progressLabel,
    required this.currentLessonId,
    required this.courseId,
    required this.lessonId,
    required this.startTime,
    required this.duration,
    required this.appImage,
    required this.author,
    required this.lessonType,
    required this.categoriesObject,
    required this.hash,
    required this.fromCache,
  });

  factory PostsBean.fromJson(Map<String, dynamic> json) => _$PostsBeanFromJson(json);

  @JsonKey(name: 'image_id')
  dynamic imageId;
  dynamic title;
  dynamic link;
  dynamic image;
  List<dynamic> terms;
  @JsonKey(name: 'terms_list')
  List<dynamic> termsList;
  dynamic views;
  dynamic price;
  @JsonKey(name: 'sale_price')
  dynamic salePrice;
  @JsonKey(name: 'post_status')
  PostStatusBean? postStatus;
  dynamic progress;
  @JsonKey(name: 'progress_label')
  dynamic progressLabel;
  @JsonKey(name: 'current_lesson_id')
  dynamic currentLessonId;
  @JsonKey(name: 'course_id')
  dynamic courseId;
  @JsonKey(name: 'lesson_id')
  dynamic lessonId;
  @JsonKey(name: 'start_time')
  dynamic startTime;
  dynamic duration;
  @JsonKey(name: 'app_image')
  dynamic appImage;
  PostAuthorBean? author;
  @JsonKey(name: 'lesson_type')
  String? lessonType;
  String? hash;
  @JsonKey(name: 'categories_object')
  List<Category?> categoriesObject;
  bool? fromCache;

  Map<String, dynamic> toJson() => _$PostsBeanToJson(this);
}

@JsonSerializable()
class PostStatusBean {
  PostStatusBean({required this.status, required this.label});

  factory PostStatusBean.fromJson(Map<String, dynamic> json) => _$PostStatusBeanFromJson(json);

  String status;
  String label;

  Map<String, dynamic> toJson() => _$PostStatusBeanToJson(this);
}

@JsonSerializable()
class PostAuthorBean {
  PostAuthorBean({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.url,
    required this.meta,
  });

  factory PostAuthorBean.fromJson(Map<String, dynamic> json) => _$PostAuthorBeanFromJson(json);

  String? id;
  String? login;
  @JsonKey(name: 'avatar_url')
  String? avatarUrl;
  String? url;
  AuthorMetaBean? meta;

  Map<String, dynamic> toJson() => _$PostAuthorBeanToJson(this);
}

@JsonSerializable()
class AuthorMetaBean {
  AuthorMetaBean({required this.type, required this.label, required this.text});

  factory AuthorMetaBean.fromJson(Map<String, dynamic> json) => _$AuthorMetaBeanFromJson(json);

  String? type;
  String? label;
  String? text;

  Map<String, dynamic> toJson() => _$AuthorMetaBeanToJson(this);
}
