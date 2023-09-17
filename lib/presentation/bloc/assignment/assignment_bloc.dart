import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/assignment/assignment_response.dart';
import 'package:masterstudy_app/data/repository/assignment_repository.dart';
import 'package:meta/meta.dart';

part 'assignment_event.dart';

part 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  AssignmentBloc() : super(InitialAssignmentState()) {
    on<LoadAssignmentEvent>((event, emit) async {
      emit(InitialAssignmentState());
      try {
        final AssignmentResponse assignment = await _assignmentRepository.getAssignmentInfo(
          event.courseId,
          event.assignmentId,
        );

        emit(LoadedAssignmentState(assignment));
      } catch (e, s) {
        logger.e('Error with method getAssignmentInfo()', e, s);
        emit(ErrorAssignmentState(e.toString()));
      }
    });

    on<StartAssignmentEvent>((event, emit) async {
      emit(LoadingStartAssignmentState());
      try {
        await _assignmentRepository.startAssignment(event.courseId, event.assignmentId);

        AssignmentResponse assignment =
            await _assignmentRepository.getAssignmentInfo(event.courseId, event.assignmentId);

        emit(LoadedAssignmentState(assignment));
      } catch (e, s) {
        logger.e('Error with startAssignment || getAssignmentInfo', e, s);
        emit(ErrorAssignmentState(e.toString()));
      }
    });

    on<AddAssignmentEvent>((event, emit) async {
      emit(LoadingAddAssignmentState());

      try {
        int course_id = event.courseId;
        int user_assignment_id = event.userAssignmentId;
        if (event.files.isNotEmpty) {
          event.files.forEach((elem) {
            _assignmentRepository.uploadAssignmentFile(course_id, user_assignment_id, elem);
          });
        }

        await _assignmentRepository.addAssignment(event.courseId, event.userAssignmentId, event.content);

        AssignmentResponse assignment =
            await _assignmentRepository.getAssignmentInfo(event.courseId, event.assignmentId);

        emit(LoadedAssignmentState(assignment));
      } catch (e, s) {
        logger.e('Error with uploadAssignmentFile', e, s);
        emit(ErrorAddAssignmentState(e.toString()));
      }
    });
  }

  final AssignmentRepository _assignmentRepository = AssignmentRepositoryImpl();
}
