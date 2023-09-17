// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCourseResponse _$UserCourseResponseFromJson(Map<String, dynamic> json) => UserCourseResponse(
      posts: (json['posts'] as List<dynamic>)
          .map(
            (e) => e == null ? null : PostsBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      total: json['total'] as String?,
      offset: json['offset'] as num,
      totalPosts: json['total_posts'] as num,
      pages: json['pages'] as num,
    );

Map<String, dynamic> _$UserCourseResponseToJson(UserCourseResponse instance) => <String, dynamic>{
      'posts': instance.posts,
      'total': instance.total,
      'offset': instance.offset,
      'total_posts': instance.totalPosts,
      'pages': instance.pages,
    };

PostsBean _$PostsBeanFromJson(Map<String, dynamic> json) => PostsBean(
      imageId: json['image_id'],
      title: json['title'],
      link: json['link'],
      image: json['image'],
      terms: json['terms'] as List<dynamic>,
      termsList: json['terms_list'] as List<dynamic>,
      views: json['views'],
      price: json['price'],
      salePrice: json['sale_price'],
      postStatus: json['post_status'] == null
          ? null
          : PostStatusBean.fromJson(
              json['post_status'] as Map<String, dynamic>,
            ),
      progress: json['progress'],
      progressLabel: json['progress_label'],
      currentLessonId: json['current_lesson_id'],
      courseId: json['course_id'],
      lessonId: json['lesson_id'],
      startTime: json['start_time'],
      duration: json['duration'],
      appImage: json['app_image'],
      author: json['author'] == null ? null : PostAuthorBean.fromJson(json['author'] as Map<String, dynamic>),
      lessonType: json['lesson_type'] as String?,
      categoriesObject: (json['categories_object'] as List<dynamic>)
          .map(
            (e) => e == null ? null : Category.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      hash: json['hash'] as String?,
      fromCache: json['fromCache'] as bool?,
    );

Map<String, dynamic> _$PostsBeanToJson(PostsBean instance) => <String, dynamic>{
      'image_id': instance.imageId,
      'title': instance.title,
      'link': instance.link,
      'image': instance.image,
      'terms': instance.terms,
      'terms_list': instance.termsList,
      'views': instance.views,
      'price': instance.price,
      'sale_price': instance.salePrice,
      'post_status': instance.postStatus,
      'progress': instance.progress,
      'progress_label': instance.progressLabel,
      'current_lesson_id': instance.currentLessonId,
      'course_id': instance.courseId,
      'lesson_id': instance.lessonId,
      'start_time': instance.startTime,
      'duration': instance.duration,
      'app_image': instance.appImage,
      'author': instance.author,
      'lesson_type': instance.lessonType,
      'hash': instance.hash,
      'categories_object': instance.categoriesObject,
      'fromCache': instance.fromCache,
    };

PostStatusBean _$PostStatusBeanFromJson(Map<String, dynamic> json) => PostStatusBean(
      status: json['status'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$PostStatusBeanToJson(PostStatusBean instance) => <String, dynamic>{
      'status': instance.status,
      'label': instance.label,
    };

PostAuthorBean _$PostAuthorBeanFromJson(Map<String, dynamic> json) => PostAuthorBean(
      id: json['id'] as String?,
      login: json['login'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      url: json['url'] as String?,
      meta: json['meta'] == null ? null : AuthorMetaBean.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostAuthorBeanToJson(PostAuthorBean instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'avatar_url': instance.avatarUrl,
      'url': instance.url,
      'meta': instance.meta,
    };

AuthorMetaBean _$AuthorMetaBeanFromJson(Map<String, dynamic> json) => AuthorMetaBean(
      type: json['type'] as String?,
      label: json['label'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$AuthorMetaBeanToJson(AuthorMetaBean instance) => <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'text': instance.text,
    };
