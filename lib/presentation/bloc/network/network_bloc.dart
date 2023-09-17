import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'network_event.dart';

part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitialState()) {
    on<NetworkObserveEvent>(
      (event, emit) => emit.onEach(
        Connectivity().onConnectivityChanged,
        onData: (ConnectivityResult connectivity) {
          if (connectivity == ConnectivityResult.none) {
            add(NetworkNotifyEvent());
          } else if (connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi) {
            add(NetworkNotifyEvent(isConnected: true));
          }
        },
      ),
    );

    on<NetworkNotifyEvent>((event, emit) async {
      event.isConnected ? emit(NetworkSuccessState()) : emit(NetworkFailureState());
    });
  }
}
