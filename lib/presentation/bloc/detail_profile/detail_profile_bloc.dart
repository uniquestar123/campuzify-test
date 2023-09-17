import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/account/account.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/data/repository/account_repository.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:meta/meta.dart';

part 'detail_profile_event.dart';

part 'detail_profile_state.dart';

class DetailProfileBloc extends Bloc<DetailProfileEvent, DetailProfileState> {
  DetailProfileBloc() : super(InitialDetailProfileState()) {
    on<FetchDetailProfile>((event, emit) async {
      bool isTeacher = event.id != null;

      emit(InitialDetailProfileState());

      try {
        account = await _repository.getAccountById(event.id);
        if (event.id != null) {
          courses = await _coursesRepository.getCourses(authorId: event.id!);
        }

        emit(LoadedDetailProfileState(courses != null ? courses!.courses : null, isTeacher));
      } catch (e, s) {
        logger.e('Error with getAccountById/getCourses', e, s);
      }
    });
  }

  final AccountRepository _repository = AccountRepositoryImpl();
  final CoursesRepository _coursesRepository = CoursesRepositoryImpl();

  Account? account;
  CoursesResponse? courses;
}
