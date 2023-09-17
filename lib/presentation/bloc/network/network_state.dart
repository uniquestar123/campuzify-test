part of 'network_bloc.dart';

abstract class NetworkState {}

class NetworkInitialState extends NetworkState {}

class NetworkSuccessState extends NetworkState {}

class NetworkFailureState extends NetworkState {}
