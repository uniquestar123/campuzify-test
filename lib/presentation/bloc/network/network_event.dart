part of 'network_bloc.dart';

abstract class NetworkEvent {}

class NetworkObserveEvent extends NetworkEvent {}

class NetworkNotifyEvent extends NetworkEvent {
  NetworkNotifyEvent({this.isConnected = false});

  final bool isConnected;
}
