// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoursesResponse _$CoursesResponseFromJson(Map<String, dynamic> json) => CoursesResponse(
      page: json['page'] as int?,
      courses: (json['courses'] as List<dynamic>)
          .map(
            (e) => e == null ? null : CoursesBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      totalPages: json['total_pages'] as int?,
    );

Map<String, dynamic> _$CoursesResponseToJson(CoursesResponse instance) => <String, dynamic>{
      'page': instance.page,
      'courses': instance.courses,
      'total_pages': instance.totalPages,
    };

CoursesBean _$CoursesBeanFromJson(Map<String, dynamic> json) => CoursesBean(
      id: json['id'] as int,
      title: json['title'] as String?,
      images: json['images'] == null ? null : ImagesBean.fromJson(json['images'] as Map<String, dynamic>),
      notSaleable: json['not_saleable'] as bool,
      categories: (json['categories'] as List<dynamic>).map((e) => e as String?).toList(),
      price: json['price'] == null ? null : PriceBean.fromJson(json['price'] as Map<String, dynamic>),
      rating: json['rating'] == null ? null : RatingBean.fromJson(json['rating'] as Map<String, dynamic>),
      isFavorite: json['is_favorite'] as bool,
      featured: json['featured'] as String?,
      status: json['status'] == null ? null : StatusBean.fromJson(json['status'] as Map<String, dynamic>),
      categoriesObject: (json['categories_object'] as List<dynamic>)
          .map(
            (e) => e == null ? null : Category.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$CoursesBeanToJson(CoursesBean instance) => <String, dynamic>{
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
    };

PriceBean _$PriceBeanFromJson(Map<String, dynamic> json) => PriceBean(
      free: json['free'] as bool,
      price: json['price'] as String?,
      oldPrice: json['old_price'] as String?,
    );

Map<String, dynamic> _$PriceBeanToJson(PriceBean instance) => <String, dynamic>{
      'free': instance.free,
      'price': instance.price,
      'old_price': instance.oldPrice,
    };

StatusBean _$StatusBeanFromJson(Map<String, dynamic> json) => StatusBean(
      status: json['status'] as String?,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$StatusBeanToJson(StatusBean instance) => <String, dynamic>{
      'status': instance.status,
      'label': instance.label,
    };

RatingBean _$RatingBeanFromJson(Map<String, dynamic> json) => RatingBean(
      average: json['average'] as num?,
      total: json['total'] as num?,
      percent: json['percent'] as num?,
    );

Map<String, dynamic> _$RatingBeanToJson(RatingBean instance) => <String, dynamic>{
      'average': instance.average,
      'total': instance.total,
      'percent': instance.percent,
    };

ImagesBean _$ImagesBeanFromJson(Map<String, dynamic> json) => ImagesBean(
      full: json['full'] as String?,
      small: json['small'] as String?,
    );

Map<String, dynamic> _$ImagesBeanToJson(ImagesBean instance) => <String, dynamic>{
      'full': instance.full,
      'small': instance.small,
    };
