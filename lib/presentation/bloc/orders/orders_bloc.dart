import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/orders/orders_response.dart';
import 'package:masterstudy_app/data/repository/purchase_repository.dart';
import 'package:meta/meta.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(InitialOrdersState()) {
    on<FetchEvent>((event, emit) async {
      try {
        var orders = await _repository.getOrders();

        if (orders.posts.isEmpty && orders.memberships.isEmpty) {
          emit(EmptyOrdersState());
          emit(EmptyMembershipsState());
        } else if (orders.posts.isNotEmpty && orders.memberships.isEmpty) {
          emit(EmptyMembershipsState());
          emit(LoadedOrdersState(orders));
        } else if (orders.posts.isEmpty && orders.memberships.isNotEmpty) {
          emit(EmptyOrdersState());
          emit(LoadedOrdersState(orders));
        } else {
          emit(LoadedOrdersState(orders));
        }
      } catch (e, s) {
        logger.e('Error getOrders', e, s);
      }
    });
  }

  final PurchaseRepository _repository = PurchaseRepositoryImpl();
}
