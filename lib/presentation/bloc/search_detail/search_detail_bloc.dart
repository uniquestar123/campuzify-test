import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:meta/meta.dart';

part 'search_detail_event.dart';

part 'search_detail_state.dart';

class SearchDetailBloc extends Bloc<SearchDetailEvent, SearchDetailState> {
  SearchDetailBloc() : super(InitialSearchDetailState()) {
    on<FetchEvent>((event, emit) async {
      emit(LoadingSearchDetailState());
      try {
        CoursesResponse response = await _coursesRepository.getCourses(
          searchQuery: event.query,
          categoryId: event.categoryId,
        );

        emit(LoadedSearchDetailState(response.courses));
      } catch (e, s) {
        logger.e('Error getCourses', e, s);
        emit(NotingFoundSearchDetailState());
      }
    });
  }

  final CoursesRepository _coursesRepository = CoursesRepositoryImpl();
}
