part of 'lesson_materials_bloc.dart';

abstract class LessonMaterialsState {}

class InitialLessonMaterialsState extends LessonMaterialsState {}

class LoadingMaterialsState extends LessonMaterialsState {}

class LoadedMaterialState extends LessonMaterialsState {}

class ErrorMaterialState extends LessonMaterialsState {
  ErrorMaterialState(this.message);

  final String? message;
}
