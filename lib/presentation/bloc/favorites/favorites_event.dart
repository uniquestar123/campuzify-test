part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesEvent {}

class FetchFavorites extends FavoritesEvent {}

class DeleteEvent extends FavoritesEvent {
  DeleteEvent(this.courseId);

  final int courseId;
}
