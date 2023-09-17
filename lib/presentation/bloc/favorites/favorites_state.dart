part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesState {}

class InitialFavoritesState extends FavoritesState {}

class EmptyFavoritesState extends FavoritesState {}

class LoadedFavoritesState extends FavoritesState {
  LoadedFavoritesState(this.favoriteCourses);

  final List<CoursesBean?> favoriteCourses;
}

class ErrorFavoritesState extends FavoritesState {}

class SuccessDeleteFavoriteCourseState extends FavoritesState {}

class UnauthorizedState extends FavoritesState {}
