import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:meta/meta.dart';

part 'home_simple_event.dart';

part 'home_simple_state.dart';

class HomeSimpleBloc extends Bloc<HomeSimpleEvent, HomeSimpleState> {
  HomeSimpleBloc() : super(InitialHomeSimpleState()) {
    on<LoadHomeSimpleEvent>((event, emit) async {
      try {
        final coursesNew = await _coursesRepository.getCourses(sort: Sort.date_low);

        if (coursesNew.courses.isEmpty) {
          emit(EmptyHomeSimpleState());
        } else {
          emit(LoadedHomeSimpleState(coursesNew.courses));
        }
      } catch (e, s) {
        logger.e('Error with method getCourses() - Home Simple Bloc', e, s);
        emit(ErrorHomeSimpleState());
      }
    });
  }

  final CoursesRepository _coursesRepository = CoursesRepositoryImpl();
}
