import 'package:json_annotation/json_annotation.dart';

part 'orders_response.g.dart';

@JsonSerializable()
class OrdersResponse {
  OrdersResponse({
    required this.posts,
    required this.memberships,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => _$OrdersResponseFromJson(json);

  final List<OrderBean?> posts;
  final List<MembershipBean?> memberships;

  Map<String, dynamic> toJson() => _$OrdersResponseToJson(this);
}

@JsonSerializable()
class OrderBean {
  OrderBean({
    required this.userId,
    required this.items,
    required this.date,
    required this.status,
    required this.paymentCode,
    required this.orderKey,
    required this.orderTotal,
    required this.orderCurrency,
    required this.i18n,
    required this.id,
    required this.dateFormatted,
    required this.cartItems,
    required this.total,
    required this.user,
  });

  factory OrderBean.fromJson(Map<String, dynamic> json) => _$OrderBeanFromJson(json);

  @JsonKey(name: 'user_id')
  String userId;
  List<ItemsBean?> items;
  String date;
  String status;
  @JsonKey(name: 'payment_code')
  String paymentCode;
  @JsonKey(name: 'order_key')
  String orderKey;
  @JsonKey(name: '_order_total')
  String orderTotal;
  @JsonKey(name: '_order_currency')
  String orderCurrency;
  I18nBean? i18n;
  num id;
  @JsonKey(name: 'date_formatted')
  String dateFormatted;
  @JsonKey(name: 'cart_items')
  List<CartItemsBean?> cartItems;
  String total;
  UserBean? user;

  Map<String, dynamic> toJson() => _$OrderBeanToJson(this);
}

@JsonSerializable()
class UserBean {
  UserBean({
    required this.id,
    required this.login,
    required this.avatar,
    required this.avatarUrl,
    required this.email,
    required this.url,
  });

  factory UserBean.fromJson(Map<String, dynamic> json) => _$UserBeanFromJson(json);

  num id;
  String login;
  String avatar;
  @JsonKey(name: 'avatar_url')
  String avatarUrl;
  String email;
  String url;

  Map<String, dynamic> toJson() => _$UserBeanToJson(this);
}

@JsonSerializable()
class CartItemsBean {
  CartItemsBean({
    required this.cartItemId,
    required this.title,
    required this.image,
    required this.status,
    this.price,
    required this.terms,
    required this.priceFormatted,
    required this.imageUrl,
  });

  factory CartItemsBean.fromJson(Map<String, dynamic> json) => _$CartItemsBeanFromJson(json);

  @JsonKey(name: 'cart_item_id')
  int cartItemId;
  String title;
  String image;
  @JsonKey(name: 'image_url')
  String imageUrl;
  String status;
  dynamic price;
  List<String?> terms;
  @JsonKey(name: 'price_formatted')
  String priceFormatted;

  Map<String, dynamic> toJson() => _$CartItemsBeanToJson(this);
}

@JsonSerializable()
class I18nBean {
  I18nBean({
    required this.orderKey,
    required this.date,
    required this.status,
    required this.pending,
    required this.processing,
    required this.failed,
    required this.onHold,
    required this.refunded,
    required this.completed,
    required this.cancelled,
    required this.user,
    required this.orderItems,
    required this.courseName,
    required this.coursePrice,
    required this.total,
  });

  factory I18nBean.fromJson(Map<String, dynamic> json) => _$I18nBeanFromJson(json);

  @JsonKey(name: 'order_key')
  String orderKey;
  String date;
  String status;
  String pending;
  String processing;
  String failed;
  @JsonKey(name: 'on-hold')
  String onHold;
  String refunded;
  String completed;
  String cancelled;
  String user;
  @JsonKey(name: 'order_items')
  String orderItems;
  @JsonKey(name: 'course_name')
  String courseName;
  @JsonKey(name: 'course_price')
  String coursePrice;
  String total;

  Map<String, dynamic> toJson() => _$I18nBeanToJson(this);
}

@JsonSerializable()
class ItemsBean {
  ItemsBean({required this.itemId, required this.price});

  factory ItemsBean.fromJson(Map<String, dynamic> json) => _$ItemsBeanFromJson(json);
  @JsonKey(name: 'item_id')
  String itemId;
  String price;

  Map<String, dynamic> toJson() => _$ItemsBeanToJson(this);
}

//Membership
@JsonSerializable()
class MembershipBean {
  MembershipBean({
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
    required this.status,
  });

  factory MembershipBean.fromJson(Map<String, dynamic> json) => _$MembershipBeanFromJson(json);

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
  @JsonKey(name: 'startdate')
  String startDate;
  @JsonKey(name: 'enddate')
  String endDate;
  @JsonKey(name: 'course_number')
  String courseNumber;
  String features;
  @JsonKey(name: 'used_quotas')
  num usedQuotas;
  @JsonKey(name: 'quotas_left')
  num quotasLeft;
  ButtonBean? button;
  String status;

  Map<String, dynamic> toJson() => _$MembershipBeanToJson(this);
}

@JsonSerializable()
class ButtonBean {
  ButtonBean({required this.text, required this.url});

  factory ButtonBean.fromJson(Map<String, dynamic> json) => _$ButtonBeanFromJson(json);
  String text;
  String url;

  Map<String, dynamic> toJson() => _$ButtonBeanToJson(this);
}
