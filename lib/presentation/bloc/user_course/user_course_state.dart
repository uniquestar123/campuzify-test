part of 'user_course_bloc.dart';

@immutable
abstract class UserCourseState {}

class InitialUserCourseState extends UserCourseState {}

class ErrorUserCourseState extends UserCourseState {}

class LoadedUserCourseState extends UserCourseState {
  LoadedUserCourseState({
    required this.sections,
    required this.materials,
    this.progress,
    required this.currentLessonId,
    required this.lessonType,
    this.response,
    this.isCached,
    this.showCachingProgress,
  });

  final List<SectionItem?> sections;
  final List<MaterialItem?> materials;
  final String? progress;
  final String currentLessonId;
  final String lessonType;
  final CurriculumResponse? response;
  final bool? isCached;
  final bool? showCachingProgress;
}
