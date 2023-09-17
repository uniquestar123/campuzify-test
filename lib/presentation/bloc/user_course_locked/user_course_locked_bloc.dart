import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/data/repository/user_course_repository.dart';
import 'package:meta/meta.dart';

part 'user_course_locked_event.dart';

part 'user_course_locked_state.dart';

class UserCourseLockedBloc extends Bloc<UserCourseLockedEvent, UserCourseLockedState> {
  UserCourseLockedBloc() : super(InitialUserCourseLockedState()) {
    on<FetchEvent>((event, emit) async {
      try {
        var response = await _repository.getCourse(event.courseId);
        emit(LoadedUserCourseLockedState(response));
      } catch (e, s) {
        logger.e('Error getCourse', e, s);
      }
    });
  }

  final UserCourseRepository _repository = UserCourseRepositoryImpl();
}
