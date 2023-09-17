part of 'search_detail_bloc.dart';

@immutable
abstract class SearchDetailEvent {}

class FetchEvent extends SearchDetailEvent {
  FetchEvent(this.query, this.categoryId);

  final String? query;
  final int? categoryId;
}
