part of 'lesson_materials_bloc.dart';

abstract class LessonMaterialsEvent {}

class LoadMaterialsEvent extends LessonMaterialsEvent {
  LoadMaterialsEvent({
    required this.url,
    required this.fileName,
  });

  final String url;
  final String fileName;
}
