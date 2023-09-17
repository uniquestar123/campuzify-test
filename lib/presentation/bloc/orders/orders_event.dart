part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}

class FetchEvent extends OrdersEvent{}