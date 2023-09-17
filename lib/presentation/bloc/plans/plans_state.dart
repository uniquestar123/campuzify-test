part of 'plans_bloc.dart';

@immutable
abstract class PlansState {}

class InitialPlansState extends PlansState {}

class LoadedPlansState extends PlansState {
  LoadedPlansState(this.plans);

  final List<AllPlansBean> plans;
}
