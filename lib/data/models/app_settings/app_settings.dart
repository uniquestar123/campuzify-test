import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

@JsonSerializable()
class AppSettings {
  AppSettings({
    required this.addons,
    required this.homeLayout,
    required this.options,
    required this.demo,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  AddonsBean? addons;
  @JsonKey(name: 'home_layout')
  List<HomeLayoutBean?> homeLayout;
  OptionsBean? options;
  bool? demo;

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

@JsonSerializable()
class AddonsBean {
  AddonsBean({
    required this.shareware,
    required this.sequentialDripContent,
    required this.gradebook,
    required this.liveStreams,
    required this.enterpriseCourses,
    required this.assignments,
    required this.pointSystem,
    required this.statistics,
    required this.onlineTesting,
    required this.courseBundle,
    required this.multiInstructors,
  });

  factory AddonsBean.fromJson(Map<String, dynamic> json) => _$AddonsBeanFromJson(json);

  String? shareware;
  @JsonKey(name: 'sequential_drip_content')
  String? sequentialDripContent;
  String? gradebook;
  @JsonKey(name: 'live_streams')
  String? liveStreams;
  @JsonKey(name: 'enterprise_courses')
  String? enterpriseCourses;
  String? assignments;
  @JsonKey(name: 'point_system')
  String? pointSystem;
  String? statistics;
  @JsonKey(name: 'online_testing')
  String? onlineTesting;
  @JsonKey(name: 'course_bundle')
  String? courseBundle;
  @JsonKey(name: 'multi_instructors')
  String? multiInstructors;

  Map<String, dynamic> toJson() => _$AddonsBeanToJson(this);
}

@JsonSerializable()
class HomeLayoutBean {
  HomeLayoutBean({
    required this.id,
    required this.name,
    required this.enabled,
  });

  factory HomeLayoutBean.fromJson(Map<String, dynamic> json) => _$HomeLayoutBeanFromJson(json);

  int id;
  String name;
  bool enabled;

  Map<String, dynamic> toJson() => _$HomeLayoutBeanToJson(this);
}

@JsonSerializable()
class OptionsBean {
  OptionsBean({
    this.subscriptions,
    this.googleOauth,
    this.facebookOauth,
    required this.logo,
    this.mainColor,
    this.mainColorHex,
    required this.secondaryColor,
    required this.secondaryColorHex,
    required this.appView,
    required this.postsCount,
  });

  factory OptionsBean.fromJson(Map<String, dynamic> json) => _$OptionsBeanFromJson(json);

  bool? subscriptions;
  @JsonKey(name: 'google_oauth')
  bool? googleOauth;
  @JsonKey(name: 'facebook_oauth')
  bool? facebookOauth;
  String? logo;
  @JsonKey(name: 'main_color')
  ColorBean? mainColor;
  @JsonKey(name: 'main_color_hex')
  String? mainColorHex;
  @JsonKey(name: 'secondary_color')
  ColorBean? secondaryColor;
  @JsonKey(name: 'secondary_color_hex')
  String? secondaryColorHex;
  @JsonKey(name: 'app_view')
  bool appView;
  @JsonKey(name: 'posts_count')
  num postsCount;

  Map<String, dynamic> toJson() => _$OptionsBeanToJson(this);
}

@JsonSerializable()
class ColorBean {
  ColorBean({required this.r, required this.g, required this.b, required this.a});

  factory ColorBean.fromJson(Map<String, dynamic> json) => _$ColorBeanFromJson(json);

  num r;
  num g;
  num b;
  num a;

  Map<String, dynamic> toJson() => _$ColorBeanToJson(this);
}
