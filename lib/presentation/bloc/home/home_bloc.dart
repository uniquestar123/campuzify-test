import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/app_settings/app_settings.dart';
import 'package:masterstudy_app/data/models/category/category.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/data/models/instructors/instructors_response.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/repository/home_repository.dart';
import 'package:masterstudy_app/data/repository/instructors_repository.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialHomeState()) {
    on<LoadHomeEvent>((event, emit) async {
      List<HomeLayoutBean?> layouts;

      try {
        AppSettings appSettings = await _homeRepository.getAppSettings();

        layouts = appSettings.homeLayout;

        // Check if params enabled == false, we not show
        layouts.removeWhere((element) => element!.enabled == false);

        List<Category> categories = await _homeRepository.getCategories();
        final coursesFree = await _coursesRepository.getCourses(sort: Sort.free);
        final coursesNew = await _coursesRepository.getCourses(sort: Sort.date_low);
        final coursesTrending = await _coursesRepository.getCourses(sort: Sort.rating);
        final instructors = await _instructorsRepository.getInstructors(InstructorsSort.rating);

        emit(
          LoadedHomeState(
            categoryList: categories,
            coursesTrending: coursesTrending.courses,
            layout: layouts,
            coursesNew: coursesNew.courses,
            coursesFree: coursesFree.courses,
            instructors: instructors,
            appSettings: appSettings,
          ),
        );
      } catch (e, s) {
        logger.e('Error with homeBloc', e, s);

        emit(ErrorHomeState());
      }
    });
  }

  final HomeRepository _homeRepository = HomeRepositoryImpl();
  final CoursesRepository _coursesRepository = CoursesRepositoryImpl();
  final InstructorsRepository _instructorsRepository = InstructorsRepositoryImpl();
}
