part of 'search_screen_bloc.dart';

@immutable
abstract class SearchScreenEvent {}

class FetchEvent extends SearchScreenEvent {}

class SearchEvent extends SearchScreenEvent {
  SearchEvent(this.query);

  final String query;
}
