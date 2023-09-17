part of 'category_detail_bloc.dart';

@immutable
abstract class CategoryDetailState {}

class InitialCategoryDetailState extends CategoryDetailState {}

class LoadedCategoryDetailState extends CategoryDetailState {
  LoadedCategoryDetailState(this.categoryList, this.courses);

  final List<Category> categoryList;
  final List<CoursesBean?> courses;
}

class ErrorCategoryDetailState extends CategoryDetailState {
  ErrorCategoryDetailState(this.categoryId);

  final int categoryId;
}
