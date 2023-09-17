import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/add_to_cart/add_to_cart_response.dart';
import 'package:masterstudy_app/data/models/orders/orders_response.dart';
import 'package:masterstudy_app/data/models/purchase/all_plans_response.dart';
import 'package:masterstudy_app/data/models/purchase/user_plans_response.dart';

abstract class PurchaseDataSource {
  Future<UserPlansResponse?> getUserPlans(int courseId);

  Future<AllPlansResponse> getPlans(int courseId);

  Future<OrdersResponse> getOrders();

  Future<AddToCartResponse> addToCart(int courseId);

  Future<bool?> usePlan(int courseId, int subscriptionId);
}

class PurchaseRemoteDataSource extends PurchaseDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<UserPlansResponse?> getUserPlans(int courseId) async {
    try {
      Response response = await _httpService.dio.post(
        '/user_plans',
        data: {'course_id': courseId},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      if (response.data.isEmpty) {
        return null;
      } else {
        return UserPlansResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<AllPlansResponse> getPlans(int courseId) async {
    try {
      Response response = await _httpService.dio.get(
        '/plans',
        queryParameters: {'course_id': courseId},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return AllPlansResponse.fromJsonArray(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<OrdersResponse> getOrders() async {
    try {
      Response response = await _httpService.dio.post(
        '/user_orders',
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );
      return OrdersResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<AddToCartResponse> addToCart(int courseId) async {
    try {
      Response response = await _httpService.dio.put(
        '/add_to_cart',
        data: {'id': courseId},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );
      return AddToCartResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<bool?> usePlan(int courseId, int subscriptionId) async {
    Response response = await _httpService.dio.put(
      '/use_plan',
      queryParameters: {'course_id': courseId, 'subscription_id': subscriptionId},
      options: Options(
        headers: {'requirestoken': 'true'},
      ),
    );

    if (response.statusCode == 200) return true;
    return null;
  }
}
