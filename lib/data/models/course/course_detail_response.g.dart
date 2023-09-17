// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseDetailResponse _$CourseDetailResponseFromJson(
  Map<String, dynamic> json,
) =>
    CourseDetailResponse(
      id: json['id'] as int,
      title: json['title'] as String,
      images: json['images'] == null ? null : ImagesBean.fromJson(json['images'] as Map<String, dynamic>),
      notSaleable: json['not_saleable'] as bool,
      categories: (json['categories'] as List<dynamic>).map((e) => e as String?).toList(),
      price: json['price'] == null ? null : PriceBean.fromJson(json['price'] as Map<String, dynamic>),
      rating: json['rating'] == null ? null : RatingBean.fromJson(json['rating'] as Map<String, dynamic>),
      featured: json['featured'],
      status: json['status'],
      author: json['author'] == null ? null : AuthorBean.fromJson(json['author'] as Map<String, dynamic>),
      url: json['url'] as String?,
      description: json['description'] as String?,
      meta: (json['meta'] as List<dynamic>)
          .map(
            (e) => e == null ? null : MetaBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      announcement: json['announcement'] as String?,
      purchaseLabel: json['purchase_label'] as String?,
      curriculum: (json['curriculum'] as List<dynamic>?)
          ?.map(
            (e) => e == null ? null : CurriculumBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      faq: (json['faq'] as List<dynamic>?)
          ?.map(
            (e) => e == null ? null : FaqBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      isFavorite: json['is_favorite'] as bool?,
      trial: json['trial'] as bool,
      firstLesson: json['first_lesson'],
      firstLessonType: json['first_lesson_type'] as String?,
      hasAccess: json['has_access'] as bool?,
      categoriesObject: (json['categories_object'] as List<dynamic>)
          .map(
            (e) => e == null ? null : Category.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      tokenAuth: json['token_auth'],
    );

Map<String, dynamic> _$CourseDetailResponseToJson(
  CourseDetailResponse instance,
) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'images': instance.images,
      'not_saleable': instance.notSaleable,
      'categories': instance.categories,
      'price': instance.price,
      'rating': instance.rating,
      'is_favorite': instance.isFavorite,
      'featured': instance.featured,
      'status': instance.status,
      'categories_object': instance.categoriesObject,
      'author': instance.author,
      'url': instance.url,
      'description': instance.description,
      'meta': instance.meta,
      'announcement': instance.announcement,
      'purchase_label': instance.purchaseLabel,
      'curriculum': instance.curriculum,
      'faq': instance.faq,
      'trial': instance.trial,
      'first_lesson': instance.firstLesson,
      'first_lesson_type': instance.firstLessonType,
      'has_access': instance.hasAccess,
      'token_auth': instance.tokenAuth,
    };

FaqBean _$FaqBeanFromJson(Map<String, dynamic> json) => FaqBean(
      question: json['question'] as String?,
      answer: json['answer'] as String?,
    );

Map<String, dynamic> _$FaqBeanToJson(FaqBean instance) => <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
    };

CurriculumBean _$CurriculumBeanFromJson(Map<String, dynamic> json) => CurriculumBean(
      type: json['type'] as String?,
      view: json['view'] as String?,
      label: json['label'] as String?,
      meta: json['meta'] as String?,
      lessonId: json['lesson_id'],
      hasPreview: json['has_preview'],
    );

Map<String, dynamic> _$CurriculumBeanToJson(CurriculumBean instance) => <String, dynamic>{
      'type': instance.type,
      'view': instance.view,
      'label': instance.label,
      'meta': instance.meta,
      'lesson_id': instance.lessonId,
      'has_preview': instance.hasPreview,
    };

MetaBean _$MetaBeanFromJson(Map<String, dynamic> json) => MetaBean(
      type: json['type'] as String,
      label: json['label'] as String,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$MetaBeanToJson(MetaBean instance) => <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'text': instance.text,
    };

AuthorBean _$AuthorBeanFromJson(Map<String, dynamic> json) => AuthorBean(
      id: json['id'] as num?,
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String?,
      url: json['url'] as String?,
      meta: json['meta'] == null ? null : AuthorMetaBean.fromJson(json['meta'] as Map<String, dynamic>),
      rating: json['rating'] == null ? null : AuthorRatingBean.fromJson(json['rating'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthorBeanToJson(AuthorBean instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'avatar_url': instance.avatarUrl,
      'url': instance.url,
      'meta': instance.meta,
      'rating': instance.rating,
    };

AuthorMetaBean _$AuthorMetaBeanFromJson(Map<String, dynamic> json) => AuthorMetaBean(
      facebook: json['facebook'] as String?,
      twitter: json['twitter'] as String?,
      instagram: json['instagram'] as String?,
      googlePlus: json['google-plus'] as String?,
      position: json['position'] as String?,
      description: json['description'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );

Map<String, dynamic> _$AuthorMetaBeanToJson(AuthorMetaBean instance) => <String, dynamic>{
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'instagram': instance.instagram,
      'google-plus': instance.googlePlus,
      'position': instance.position,
      'description': instance.description,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };

AuthorRatingBean _$AuthorRatingBeanFromJson(Map<String, dynamic> json) => AuthorRatingBean(
      total: json['total'] as num?,
      average: json['average'] as num?,
      marksNum: json['marks_num'] as num?,
      totalMarks: json['total_marks'] as String?,
      percent: json['percent'] as num?,
    );

Map<String, dynamic> _$AuthorRatingBeanToJson(AuthorRatingBean instance) => <String, dynamic>{
      'total': instance.total,
      'average': instance.average,
      'marks_num': instance.marksNum,
      'total_marks': instance.totalMarks,
      'percent': instance.percent,
    };

RatingBean _$RatingBeanFromJson(Map<String, dynamic> json) => RatingBean(
      total: json['total'] as int,
      average: json['average'] as num?,
      percent: json['percent'] as num?,
      details: json['details'] == null ? null : DetailsBean.fromJson(json['details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RatingBeanToJson(RatingBean instance) => <String, dynamic>{
      'average': instance.average,
      'total': instance.total,
      'percent': instance.percent,
      'details': instance.details,
    };

DetailsBean _$DetailsBeanFromJson(Map<String, dynamic> json) => DetailsBean(
      one: json['1'] as num,
      two: json['2'] as num,
      three: json['3'] as num,
      four: json['4'] as num,
      five: json['5'] as num,
    );

Map<String, dynamic> _$DetailsBeanToJson(DetailsBean instance) => <String, dynamic>{
      '1': instance.one,
      '2': instance.two,
      '3': instance.three,
      '4': instance.four,
      '5': instance.five,
    };

PriceBean _$PriceBeanFromJson(Map<String, dynamic> json) => PriceBean(
      free: json['free'] as bool?,
      price: json['price'] as String?,
      oldPrice: json['old_price'] as String?,
    );

Map<String, dynamic> _$PriceBeanToJson(PriceBean instance) => <String, dynamic>{
      'free': instance.free,
      'price': instance.price,
      'old_price': instance.oldPrice,
    };

ImagesBean _$ImagesBeanFromJson(Map<String, dynamic> json) => ImagesBean(
      full: json['full'] as String?,
      small: json['small'] as String?,
    );

Map<String, dynamic> _$ImagesBeanToJson(ImagesBean instance) => <String, dynamic>{
      'full': instance.full,
      'small': instance.small,
    };

TokenAuthToCourse _$TokenAuthToCourseFromJson(Map<String, dynamic> json) => TokenAuthToCourse(
      tokenAuth: json['token_auth'] as String?,
    );

Map<String, dynamic> _$TokenAuthToCourseToJson(TokenAuthToCourse instance) => <String, dynamic>{
      'token_auth': instance.tokenAuth,
    };
