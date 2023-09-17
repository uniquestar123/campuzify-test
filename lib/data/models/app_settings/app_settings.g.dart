// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      addons: json['addons'] == null ? null : AddonsBean.fromJson(json['addons'] as Map<String, dynamic>),
      homeLayout: (json['home_layout'] as List<dynamic>)
          .map(
            (e) => e == null ? null : HomeLayoutBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      options: json['options'] == null ? null : OptionsBean.fromJson(json['options'] as Map<String, dynamic>),
      demo: json['demo'] as bool?,
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) => <String, dynamic>{
      'addons': instance.addons,
      'home_layout': instance.homeLayout,
      'options': instance.options,
      'demo': instance.demo,
    };

AddonsBean _$AddonsBeanFromJson(Map<String, dynamic> json) => AddonsBean(
      shareware: json['shareware'] as String?,
      sequentialDripContent: json['sequential_drip_content'] as String?,
      gradebook: json['gradebook'] as String?,
      liveStreams: json['live_streams'] as String?,
      enterpriseCourses: json['enterprise_courses'] as String?,
      assignments: json['assignments'] as String?,
      pointSystem: json['point_system'] as String?,
      statistics: json['statistics'] as String?,
      onlineTesting: json['online_testing'] as String?,
      courseBundle: json['course_bundle'] as String?,
      multiInstructors: json['multi_instructors'] as String?,
    );

Map<String, dynamic> _$AddonsBeanToJson(AddonsBean instance) => <String, dynamic>{
      'shareware': instance.shareware,
      'sequential_drip_content': instance.sequentialDripContent,
      'gradebook': instance.gradebook,
      'live_streams': instance.liveStreams,
      'enterprise_courses': instance.enterpriseCourses,
      'assignments': instance.assignments,
      'point_system': instance.pointSystem,
      'statistics': instance.statistics,
      'online_testing': instance.onlineTesting,
      'course_bundle': instance.courseBundle,
      'multi_instructors': instance.multiInstructors,
    };

HomeLayoutBean _$HomeLayoutBeanFromJson(Map<String, dynamic> json) => HomeLayoutBean(
      id: json['id'] as int,
      name: json['name'] as String,
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$HomeLayoutBeanToJson(HomeLayoutBean instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'enabled': instance.enabled,
    };

OptionsBean _$OptionsBeanFromJson(Map<String, dynamic> json) => OptionsBean(
      subscriptions: json['subscriptions'] as bool?,
      googleOauth: json['google_oauth'] as bool?,
      facebookOauth: json['facebook_oauth'] as bool?,
      logo: json['logo'] as String?,
      mainColor: json['main_color'] == null ? null : ColorBean.fromJson(json['main_color'] as Map<String, dynamic>),
      mainColorHex: json['main_color_hex'] as String?,
      secondaryColor:
          json['secondary_color'] == null ? null : ColorBean.fromJson(json['secondary_color'] as Map<String, dynamic>),
      secondaryColorHex: json['secondary_color_hex'] as String?,
      appView: json['app_view'] as bool,
      postsCount: json['posts_count'] as num,
    );

Map<String, dynamic> _$OptionsBeanToJson(OptionsBean instance) => <String, dynamic>{
      'subscriptions': instance.subscriptions,
      'google_oauth': instance.googleOauth,
      'facebook_oauth': instance.facebookOauth,
      'logo': instance.logo,
      'main_color': instance.mainColor,
      'main_color_hex': instance.mainColorHex,
      'secondary_color': instance.secondaryColor,
      'secondary_color_hex': instance.secondaryColorHex,
      'app_view': instance.appView,
      'posts_count': instance.postsCount,
    };

ColorBean _$ColorBeanFromJson(Map<String, dynamic> json) => ColorBean(
      r: json['r'] as num,
      g: json['g'] as num,
      b: json['b'] as num,
      a: json['a'] as num,
    );

Map<String, dynamic> _$ColorBeanToJson(ColorBean instance) => <String, dynamic>{
      'r': instance.r,
      'g': instance.g,
      'b': instance.b,
      'a': instance.a,
    };
