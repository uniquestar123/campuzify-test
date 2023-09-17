import 'package:masterstudy_app/data/datasources/purchase_datasource.dart';
import 'package:masterstudy_app/data/models/add_to_cart/add_to_cart_response.dart';
import 'package:masterstudy_app/data/models/orders/orders_response.dart';
import 'package:masterstudy_app/data/models/purchase/all_plans_response.dart';
import 'package:masterstudy_app/data/models/purchase/user_plans_response.dart';

abstract class PurchaseRepository {
  Future<UserPlansResponse?> getUserPlans(int courseId);

  Future<List<AllPlansBean>> getPlans({int courseId});

  Future<OrdersResponse> getOrders();

  Future<AddToCartResponse> addToCart(int courseId);

  Future usePlan(int courseId, int subscriptionId);
}

class PurchaseRepositoryImpl extends PurchaseRepository {
  final PurchaseDataSource _purchaseDataSource = PurchaseRemoteDataSource();

  @override
  Future<UserPlansResponse?> getUserPlans(int courseId) async => await _purchaseDataSource.getUserPlans(courseId);

  @override
  Future<List<AllPlansBean>> getPlans({dynamic courseId}) async {
    var response = await _purchaseDataSource.getPlans(courseId);
    return response.plans;
  }

  @override
  Future<OrdersResponse> getOrders() async => await _purchaseDataSource.getOrders();

  @override
  Future<AddToCartResponse> addToCart(int courseId) async {
    final response = await _purchaseDataSource.addToCart(courseId);
    return response;
  }

  @override
  Future usePlan(int courseId, int subscriptionId) async => await _purchaseDataSource.usePlan(courseId, subscriptionId);
}
