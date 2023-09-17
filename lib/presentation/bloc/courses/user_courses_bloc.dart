import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/cache/cache_manager.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/user_course/user_course.dart';
import 'package:masterstudy_app/data/repository/user_course_repository.dart';

part 'user_courses_event.dart';

part 'user_courses_state.dart';

class UserCoursesBloc extends Bloc<UserCoursesEvent, UserCoursesState> {
  UserCoursesBloc() : super(InitialUserCoursesState()) {
    on<LoadUserCoursesEvent>((event, emit) async {
      emit(InitialUserCoursesState());

      if (!await isAuth()) {
        emit(UnauthorizedState());
        return;
      }

      try {
        final UserCourseResponse response = await _userCourseRepository.getUserCourses();

        _userCourseRepository.saveLocalUserCourses(response);

        if (response.posts.isEmpty) {
          emit(EmptyCoursesState());
        } else {
          emit(LoadedCoursesState(response.posts));
        }
      } catch (e) {
        final cache = await _cacheManager.getFromCache();

        if (cache != null) {
          List<UserCourseResponse> response = await _userCourseRepository.getUserCoursesLocal();

          for (var el in response) {
            for (var el1 in el.posts) {
              for (var el2 in cache.courses) {
                if (el1!.hash == el2!.hash) {
                  el2.postsBean!.progress = el1.progress;
                  el2.postsBean!.progressLabel = el1.progressLabel;
                }
              }
            }
          }

          try {
            List<PostsBean?> list = [];

            cache.courses.forEach((element) {
              list.add(element?.postsBean!);
            });

            emit(LoadedCoursesState(list));
          } catch (e) {
            emit(ErrorUserCoursesState());
          }
        } else {
          emit(EmptyCacheCoursesState());
        }
      }
    });
  }

  final UserCourseRepository _userCourseRepository = UserCourseRepositoryImpl();
  final CacheManager _cacheManager = CacheManager();
}
