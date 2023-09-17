// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersResponse _$OrdersResponseFromJson(Map<String, dynamic> json) => OrdersResponse(
      posts: (json['posts'] as List<dynamic>)
          .map(
            (e) => e == null ? null : OrderBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      memberships: (json['memberships'] as List<dynamic>)
          .map(
            (e) => e == null ? null : MembershipBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$OrdersResponseToJson(OrdersResponse instance) => <String, dynamic>{
      'posts': instance.posts,
      'memberships': instance.memberships,
    };

OrderBean _$OrderBeanFromJson(Map<String, dynamic> json) => OrderBean(
      userId: json['user_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => e == null ? null : ItemsBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      date: json['date'] as String,
      status: json['status'] as String,
      paymentCode: json['payment_code'] as String,
      orderKey: json['order_key'] as String,
      orderTotal: json['_order_total'] as String,
      orderCurrency: json['_order_currency'] as String,
      i18n: json['i18n'] == null ? null : I18nBean.fromJson(json['i18n'] as Map<String, dynamic>),
      id: json['id'] as num,
      dateFormatted: json['date_formatted'] as String,
      cartItems: (json['cart_items'] as List<dynamic>)
          .map(
            (e) => e == null ? null : CartItemsBean.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      total: json['total'] as String,
      user: json['user'] == null ? null : UserBean.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderBeanToJson(OrderBean instance) => <String, dynamic>{
      'user_id': instance.userId,
      'items': instance.items,
      'date': instance.date,
      'status': instance.status,
      'payment_code': instance.paymentCode,
      'order_key': instance.orderKey,
      '_order_total': instance.orderTotal,
      '_order_currency': instance.orderCurrency,
      'i18n': instance.i18n,
      'id': instance.id,
      'date_formatted': instance.dateFormatted,
      'cart_items': instance.cartItems,
      'total': instance.total,
      'user': instance.user,
    };

UserBean _$UserBeanFromJson(Map<String, dynamic> json) => UserBean(
      id: json['id'] as num,
      login: json['login'] as String,
      avatar: json['avatar'] as String,
      avatarUrl: json['avatar_url'] as String,
      email: json['email'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$UserBeanToJson(UserBean instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'avatar': instance.avatar,
      'avatar_url': instance.avatarUrl,
      'email': instance.email,
      'url': instance.url,
    };

CartItemsBean _$CartItemsBeanFromJson(Map<String, dynamic> json) => CartItemsBean(
      cartItemId: json['cart_item_id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      status: json['status'] as String,
      price: json['price'],
      terms: (json['terms'] as List<dynamic>).map((e) => e as String?).toList(),
      priceFormatted: json['price_formatted'] as String,
      imageUrl: json['image_url'] as String,
    );

Map<String, dynamic> _$CartItemsBeanToJson(CartItemsBean instance) => <String, dynamic>{
      'cart_item_id': instance.cartItemId,
      'title': instance.title,
      'image': instance.image,
      'image_url': instance.imageUrl,
      'status': instance.status,
      'price': instance.price,
      'terms': instance.terms,
      'price_formatted': instance.priceFormatted,
    };

I18nBean _$I18nBeanFromJson(Map<String, dynamic> json) => I18nBean(
      orderKey: json['order_key'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      pending: json['pending'] as String,
      processing: json['processing'] as String,
      failed: json['failed'] as String,
      onHold: json['on-hold'] as String,
      refunded: json['refunded'] as String,
      completed: json['completed'] as String,
      cancelled: json['cancelled'] as String,
      user: json['user'] as String,
      orderItems: json['order_items'] as String,
      courseName: json['course_name'] as String,
      coursePrice: json['course_price'] as String,
      total: json['total'] as String,
    );

Map<String, dynamic> _$I18nBeanToJson(I18nBean instance) => <String, dynamic>{
      'order_key': instance.orderKey,
      'date': instance.date,
      'status': instance.status,
      'pending': instance.pending,
      'processing': instance.processing,
      'failed': instance.failed,
      'on-hold': instance.onHold,
      'refunded': instance.refunded,
      'completed': instance.completed,
      'cancelled': instance.cancelled,
      'user': instance.user,
      'order_items': instance.orderItems,
      'course_name': instance.courseName,
      'course_price': instance.coursePrice,
      'total': instance.total,
    };

ItemsBean _$ItemsBeanFromJson(Map<String, dynamic> json) => ItemsBean(
      itemId: json['item_id'] as String,
      price: json['price'] as String,
    );

Map<String, dynamic> _$ItemsBeanToJson(ItemsBean instance) => <String, dynamic>{
      'item_id': instance.itemId,
      'price': instance.price,
    };

MembershipBean _$MembershipBeanFromJson(Map<String, dynamic> json) => MembershipBean(
      ID: json['ID'] as String,
      id: json['id'] as String,
      subscriptionId: json['subscription_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      confirmation: json['confirmation'] as String,
      expirationNumber: json['expiration_number'] as String,
      expirationPeriod: json['expiration_period'] as String,
      initialPayment: json['initial_payment'] as num,
      billingAmount: json['billing_amount'] as num,
      cycleNumber: json['cycle_number'] as String,
      cyclePeriod: json['cycle_period'] as String,
      billingLimit: json['billing_limit'] as String,
      trialAmount: json['trial_amount'] as num,
      trialLimit: json['trial_limit'] as String,
      codeId: json['code_id'] as String,
      startDate: json['startdate'] as String,
      endDate: json['enddate'] as String,
      courseNumber: json['course_number'] as String,
      usedQuotas: json['used_quotas'] as num,
      quotasLeft: json['quotas_left'] as num,
      button: json['button'] == null ? null : ButtonBean.fromJson(json['button'] as Map<String, dynamic>),
      features: json['features'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$MembershipBeanToJson(MembershipBean instance) => <String, dynamic>{
      'ID': instance.ID,
      'id': instance.id,
      'subscription_id': instance.subscriptionId,
      'name': instance.name,
      'description': instance.description,
      'confirmation': instance.confirmation,
      'expiration_number': instance.expirationNumber,
      'expiration_period': instance.expirationPeriod,
      'initial_payment': instance.initialPayment,
      'billing_amount': instance.billingAmount,
      'cycle_number': instance.cycleNumber,
      'cycle_period': instance.cyclePeriod,
      'billing_limit': instance.billingLimit,
      'trial_amount': instance.trialAmount,
      'trial_limit': instance.trialLimit,
      'code_id': instance.codeId,
      'startdate': instance.startDate,
      'enddate': instance.endDate,
      'course_number': instance.courseNumber,
      'features': instance.features,
      'used_quotas': instance.usedQuotas,
      'quotas_left': instance.quotasLeft,
      'button': instance.button,
      'status': instance.status,
    };

ButtonBean _$ButtonBeanFromJson(Map<String, dynamic> json) => ButtonBean(
      text: json['text'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$ButtonBeanToJson(ButtonBean instance) => <String, dynamic>{
      'text': instance.text,
      'url': instance.url,
    };
