import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:path_provider/path_provider.dart';

part 'lesson_materials_event.dart';

part 'lesson_materials_state.dart';

class LessonMaterialsBloc extends Bloc<LessonMaterialsEvent, LessonMaterialsState> {
  LessonMaterialsBloc() : super(InitialLessonMaterialsState()) {
    CancelToken? _requestCancelToken;

    on<LoadMaterialsEvent>((event, emit) async {
      emit(LoadingMaterialsState());

      try {
        _requestCancelToken?.cancel();
        _requestCancelToken = CancelToken();

        await HttpService().dio.download(
              event.url,
              (await getApplicationDocumentsDirectory()).path + '/${event.fileName}',
              onReceiveProgress: (int received, int total) {},
              options: Options(
                responseType: ResponseType.bytes,
              ),
              cancelToken: _requestCancelToken,
            );

        emit(LoadedMaterialState());
      } on DioException catch (e) {
        emit(ErrorMaterialState(e.toString()));
      } on Exception catch (e) {
        emit(ErrorMaterialState(e.toString()));
      }
    });
  }
}
