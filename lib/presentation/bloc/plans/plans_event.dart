part of 'plans_bloc.dart';

@immutable
abstract class PlansEvent {}

class FetchEvent extends PlansEvent {}

class SelectPlan extends PlansEvent {
  SelectPlan(this.planId);

  final int planId;
}
