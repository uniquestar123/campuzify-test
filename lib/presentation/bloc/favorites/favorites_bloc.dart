import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:meta/meta.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(InitialFavoritesState()) {
    on<FetchFavorites>((event, emit) async {
      emit(InitialFavoritesState());

      if (!await isAuth()) {
        emit(UnauthorizedState());
        return;
      }

      try {
        final courses = await coursesRepository.getFavoriteCourses();
        if (courses.courses.isNotEmpty) {
          emit(LoadedFavoritesState(courses.courses));
        } else {
          emit(EmptyFavoritesState());
        }
      } catch (e, s) {
        logger.e('Error getFavoriteCourses', e, s);
        emit(ErrorFavoritesState());
      }
    });

    on<DeleteEvent>((event, emit) async {
      try {
        final courses = (state as LoadedFavoritesState).favoriteCourses;
        courses.removeWhere((item) => item?.id == event.courseId);
        await coursesRepository.deleteFavoriteCourse(event.courseId);
        emit(SuccessDeleteFavoriteCourseState());
      } catch (e, s) {
        logger.e('Error deleteFavorite', e, s);
      }
    });
  }

  final CoursesRepository coursesRepository = CoursesRepositoryImpl();
}
