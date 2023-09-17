part of 'final_bloc.dart';

@immutable
abstract class FinalState {}

class InitialFinalState extends FinalState {}

class LoadingFinalState extends FinalState {}

class LoadedFinalState extends FinalState {
  LoadedFinalState(this.finalResponse);

  final FinalResponse finalResponse;
}

class ErrorFinalState extends FinalState {}

class CacheWarningState extends FinalState {}
