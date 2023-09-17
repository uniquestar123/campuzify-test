import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/data/models/account/account.dart';
import 'package:masterstudy_app/data/models/review_add/review_add_response.dart';
import 'package:masterstudy_app/data/repository/account_repository.dart';
import 'package:masterstudy_app/data/repository/review_repository.dart';
import 'package:meta/meta.dart';

part 'review_write_event.dart';

part 'review_write_state.dart';

class ReviewWriteBloc extends Bloc<ReviewWriteEvent, ReviewWriteState> {
  ReviewWriteBloc() : super(InitialReviewWriteState()) {
    on<SaveReviewEvent>((event, emit) async {
      emit(LoadingAddReviewState());
      try {
        final ReviewAddResponse reviewAddResponse = await _reviewRepository.addReview(
          event.id,
          event.mark,
          event.review,
        );

        emit(SuccessAddReviewState(reviewAddResponse, localAccount!));
      } catch (e, s) {
        logger.e('Error with method addReview()', e, s);
        emit(ErrorAddReviewState(message: e.toString()));
      }
    });

    on<FetchEvent>((event, emit) async {
      try {
        Account account = await _accountRepository.getUserAccount();
        localAccount = account;
        emit(LoadedReviewWriteState(account));
      } catch (e, s) {
        logger.e('Error with method getUserAccount()', e, s);
        emit(ErrorLoadedReviewState(message: e.toString()));
      }
    });
  }

  Account? localAccount;
  final AccountRepository _accountRepository = AccountRepositoryImpl();
  final ReviewRepository _reviewRepository = ReviewRepositoryImpl();
}
