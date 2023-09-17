import 'package:json_annotation/json_annotation.dart';

part 'user_plans_response.g.dart';

@JsonSerializable()
class UserPlansResponse {
  UserPlansResponse({
    required this.subscriptions,
    required this.otherSubscriptions,
  });

  factory UserPlansResponse.fromJson(Map<String, dynamic> json) => _$UserPlansResponseFromJson(json);

  final List<UserPlansBean?> subscriptions;
  @JsonKey(name: 'other_subscriptions')
  final bool otherSubscriptions;

  Map<String, dynamic> toJson() => _$UserPlansResponseToJson(this);
}

@JsonSerializable()
class UserPlansBean {
  UserPlansBean({
    required this.ID,
    required this.id,
    required this.subscriptionId,
    required this.name,
    required this.description,
    required this.confirmation,
    required this.expirationNumber,
    required this.expirationPeriod,
    required this.initialPayment,
    required this.billingAmount,
    required this.cycleNumber,
    required this.cyclePeriod,
    required this.billingLimit,
    required this.trialAmount,
    required this.trialLimit,
    required this.codeId,
    required this.startdate,
    required this.enddate,
    required this.courseNumber,
    required this.usedQuotas,
    required this.quotasLeft,
    required this.button,
    required this.features,
  });

  factory UserPlansBean.fromJson(Map<String, dynamic> json) => _$UserPlansBeanFromJson(json);
  String ID;
  String id;
  @JsonKey(name: 'subscription_id')
  String subscriptionId;
  String name;
  String description;
  String confirmation;
  @JsonKey(name: 'expiration_number')
  String expirationNumber;
  @JsonKey(name: 'expiration_period')
  String expirationPeriod;
  @JsonKey(name: 'initial_payment')
  num initialPayment;
  @JsonKey(name: 'billing_amount')
  num billingAmount;
  @JsonKey(name: 'cycle_number')
  String cycleNumber;
  @JsonKey(name: 'cycle_period')
  String cyclePeriod;
  @JsonKey(name: 'billing_limit')
  String billingLimit;
  @JsonKey(name: 'trial_amount')
  num trialAmount;
  @JsonKey(name: 'trial_limit')
  String trialLimit;
  @JsonKey(name: 'code_id')
  String codeId;
  String startdate;
  String enddate;
  @JsonKey(name: 'course_number')
  String courseNumber;
  String features;
  @JsonKey(name: 'used_quotas')
  num usedQuotas;
  @JsonKey(name: 'quotas_left')
  num quotasLeft;
  ButtonBean? button;

  Map<String, dynamic> toJson() => _$UserPlansBeanToJson(this);
}

@JsonSerializable()
class ButtonBean {
  ButtonBean({required this.text, required this.url});

  factory ButtonBean.fromJson(Map<String, dynamic> json) => _$ButtonBeanFromJson(json);
  String text;
  String url;

  Map<String, dynamic> toJson() => _$ButtonBeanToJson(this);
}
