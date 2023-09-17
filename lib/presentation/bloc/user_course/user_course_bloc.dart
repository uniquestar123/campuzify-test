import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/cache/cache_manager.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/cached_course/cached_course.dart';
import 'package:masterstudy_app/data/models/curriculum/curriculum.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import 'package:masterstudy_app/data/repository/user_course_repository.dart';
import 'package:masterstudy_app/presentation/screens/user_course/user_course.dart';
import 'package:meta/meta.dart';

part 'user_course_event.dart';

part 'user_course_state.dart';

class UserCourseBloc extends Bloc<UserCourseEvent, UserCourseState> {
  UserCourseBloc() : super(InitialUserCourseState()) {
    on<FetchEvent>((event, emit) async {
      int courseId = int.parse(event.userCourseScreenArgs.course_id!);

      var isCached = await cacheManager.isCached(courseId);

      try {
        var response = await _repository.getCourseCurriculum(courseId);

        _repository.saveLocalCurriculum(response, courseId);

        emit(
          LoadedUserCourseState(
            sections: response.sections,
            materials: response.materials,
            progress: response.progressPercent,
            currentLessonId: response.currentLessonId!,
            lessonType: response.lessonType!,
            response: response = response,
            isCached: isCached,
            showCachingProgress: false,
          ),
        );

        if (isCached) {
          var currentHash =
              (await cacheManager.getFromCache())?.courses.firstWhere((element) => courseId == element?.id)?.hash;

          if (event.userCourseScreenArgs.postsBean?.hash != currentHash) {
            if (state is LoadedUserCourseState) {
              var state = this.state as LoadedUserCourseState;

              emit(
                LoadedUserCourseState(
                  sections: state.sections,
                  materials: response.materials,
                  progress: state.progress,
                  currentLessonId: state.currentLessonId,
                  lessonType: state.lessonType,
                  response: state.response,
                  isCached: false,
                  showCachingProgress: true,
                ),
              );

              try {
                CachedCourse course = CachedCourse(
                  id: int.parse(event.userCourseScreenArgs.course_id!),
                  postsBean: event.userCourseScreenArgs.postsBean?..fromCache = true,
                  curriculumResponse: (state).response,
                  hash: event.userCourseScreenArgs.hash!,
                  lessons: [],
                );

                var sections = (state).response?.sections.map((e) => e?.sectionItems);

                List<int?> iDs = [];

                sections?.forEach((element) {
                  element?.forEach((element) {
                    iDs.add(element.itemId);
                  });
                });

                course.lessons =
                    await _lessonsRepository.getAllLessons(int.parse(event.userCourseScreenArgs.course_id!), iDs);

                await cacheManager.writeToCache(course).then(
                      (value) => emit(
                        LoadedUserCourseState(
                          sections: state.sections,
                          materials: response.materials,
                          progress: state.progress,
                          currentLessonId: state.currentLessonId,
                          lessonType: state.lessonType,
                          response: state.response,
                          isCached: true,
                          showCachingProgress: false,
                        ),
                      ),
                    );
              } catch (e, s) {
                logger.e('Error getAllLessons', e, s);
                emit(
                  LoadedUserCourseState(
                    sections: state.sections,
                    materials: response.materials,
                    progress: state.progress,
                    currentLessonId: state.currentLessonId,
                    lessonType: state.lessonType,
                    response: state.response,
                    isCached: false,
                    showCachingProgress: false,
                  ),
                );
              }
            }
          }
        }
      } catch (e, s) {
        logger.e('Error during with userCourseBloc', e, s);

        if (isCached) {
          var cache = await cacheManager.getFromCache();

          if (cache?.courses.firstWhere((element) => courseId == element?.id) != null) {
            var response = cache?.courses.firstWhere((element) => courseId == element?.id)?.curriculumResponse;

            emit(
              LoadedUserCourseState(
                sections: response!.sections,
                materials: response.materials,
                progress: response.progressPercent,
                currentLessonId: response.currentLessonId!,
                lessonType: response.lessonType!,
                response: response = response,
                isCached: true,
                showCachingProgress: false,
              ),
            );
          } else {
            emit(ErrorUserCourseState());
          }
        } else {
          emit(ErrorUserCourseState());
        }
      }
    });

    on<CacheCourseEvent>((event, emit) async {
      if (state is LoadedUserCourseState) {
        var state = this.state as LoadedUserCourseState;

        emit(
          LoadedUserCourseState(
            sections: state.sections,
            materials: state.materials,
            progress: state.progress,
            currentLessonId: state.currentLessonId,
            lessonType: state.lessonType,
            response: state.response,
            isCached: false,
            showCachingProgress: true,
          ),
        );

        try {
          CachedCourse course = CachedCourse(
            id: int.parse(event.userCourseScreenArgs.course_id!),
            postsBean: event.userCourseScreenArgs.postsBean?..fromCache = true,
            curriculumResponse: (state).response,
            hash: event.userCourseScreenArgs.hash!,
            lessons: [],
          );

          var sections = (state).response?.sections.map((e) => e?.sectionItems);

          List<int?> iDs = [];

          sections?.forEach((element) {
            element?.forEach((element) {
              iDs.add(element.itemId);
            });
          });

          course.lessons =
              await _lessonsRepository.getAllLessons(int.parse(event.userCourseScreenArgs.course_id!), iDs);

          await cacheManager.writeToCache(course).then(
                (value) => emit(
                  LoadedUserCourseState(
                    sections: state.sections,
                    materials: state.materials,
                    progress: state.progress,
                    currentLessonId: state.currentLessonId,
                    lessonType: state.lessonType,
                    response: state.response,
                    isCached: true,
                    showCachingProgress: false,
                  ),
                ),
              );
        } catch (e, s) {
          logger.e('Error getAllLessons', e, s);
          emit(
            LoadedUserCourseState(
              sections: state.sections,
              materials: state.materials,
              progress: state.progress,
              currentLessonId: state.currentLessonId,
              lessonType: state.lessonType,
              response: state.response,
              isCached: false,
              showCachingProgress: false,
            ),
          );
        }
      }
    });
  }

  final UserCourseRepository _repository = UserCourseRepositoryImpl();
  final LessonRepository _lessonsRepository = LessonRepositoryImpl();
  final CacheManager cacheManager = CacheManager();
}
