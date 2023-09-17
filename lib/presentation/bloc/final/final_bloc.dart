import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/cache/cache_manager.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/final_response/final_response.dart';
import 'package:masterstudy_app/data/repository/final_repository.dart';
import 'package:meta/meta.dart';

part 'final_event.dart';

part 'final_state.dart';

class FinalBloc extends Bloc<FinalEvent, FinalState> {
  FinalBloc() : super(InitialFinalState()) {
    on<LoadFinalEvent>((event, emit) async {
      emit(LoadingFinalState());
      try {
        FinalResponse response = await _finalRepository.getCourseResults(event.courseId);

        emit(LoadedFinalState(response));
      } catch (e, s) {
        logger.e('Error getCourseResults', e, s);
        if (await cacheManager.isCached(event.courseId)) {
          emit(CacheWarningState());
        }
      }
    });
  }

  final FinalRepository _finalRepository = FinalRepositoryImpl();
  final CacheManager cacheManager = CacheManager();
}
