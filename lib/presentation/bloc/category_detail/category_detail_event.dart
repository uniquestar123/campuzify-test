part of 'category_detail_bloc.dart';

@immutable
abstract class CategoryDetailEvent {}

class FetchEvent extends CategoryDetailEvent {
  FetchEvent(this.categoryId);

  final int categoryId;
}
