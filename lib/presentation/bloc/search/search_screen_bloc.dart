import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:meta/meta.dart';

part 'search_screen_event.dart';

part 'search_screen_state.dart';

class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  SearchScreenBloc() : super(InitialSearchScreenState()) {
    on<FetchEvent>((event, emit) async {
      if (_popularSearches == null || _newCourses == null) {
        emit(InitialSearchScreenState());
        try {
          _newCourses = (await _coursesRepository.getCourses(sort: Sort.date_low)).courses.cast<CoursesBean>();

          _popularSearches = (await _coursesRepository.getPopularSearches()).searches;
          emit(LoadedSearchScreenState(_newCourses!, _popularSearches!));
        } catch (e, s) {
          logger.e('Error getPopularSearches', e, s);
          emit(ErrorSearchScreenState());
        }
      }
    });
  }

  final CoursesRepository _coursesRepository = CoursesRepositoryImpl();
  List<String>? _popularSearches;
  List<CoursesBean>? _newCourses;
}
