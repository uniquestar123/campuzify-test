part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class InitialOrdersState extends OrdersState {}

class EmptyOrdersState extends OrdersState {}

class EmptyMembershipsState extends OrdersState {}

class LoadedOrdersState extends OrdersState {
  LoadedOrdersState(this.orders);

  final OrdersResponse orders;
}
