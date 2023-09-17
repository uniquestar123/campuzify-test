import 'package:json_annotation/json_annotation.dart';

part 'all_plans_response.g.dart';

class AllPlansResponse {
  AllPlansResponse(this.plans);

  AllPlansResponse.fromJsonArray(List json) : plans = json.map((i) => new AllPlansBean.fromJson(i)).toList();

  final List<AllPlansBean> plans;
}

@JsonSerializable()
class AllPlansBean {
  AllPlansBean({
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
    required this.startDate,
    required this.endDate,
    required this.courseNumber,
    required this.usedQuotas,
    required this.quotasLeft,
    required this.button,
    required this.features,
  });

  factory AllPlansBean.fromJson(Map<String, dynamic> json) => _$AllPlansBeanFromJson(json);
  String? ID;
  String id;
  @JsonKey(name: 'subscription_id')
  String? subscriptionId;
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
  String? codeId;
  @JsonKey(name: 'startdate')
  String? startDate;
  @JsonKey(name: 'enddate')
  String? endDate;
  @JsonKey(name: 'course_number')
  String? courseNumber;
  String? features;
  @JsonKey(name: 'used_quotas')
  num? usedQuotas;
  @JsonKey(name: 'quotas_left')
  num? quotasLeft;
  ButtonBean? button;

  Map<String, dynamic> toJson() => _$AllPlansBeanToJson(this);
}

@JsonSerializable()
class ButtonBean {
  ButtonBean({required this.text, required this.url});

  factory ButtonBean.fromJson(Map<String, dynamic> json) => _$ButtonBeanFromJson(json);
  String text;
  String url;

  Map<String, dynamic> toJson() => _$ButtonBeanToJson(this);
}
