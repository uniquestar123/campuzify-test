import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/core/utils/logger.dart';
import 'package:masterstudy_app/core/utils/utils.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/data/models/purchase/all_plans_response.dart';
import 'package:masterstudy_app/data/models/purchase/user_plans_response.dart';
import 'package:masterstudy_app/data/models/review/review_response.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/repository/purchase_repository.dart';
import 'package:masterstudy_app/data/repository/review_repository.dart';
import 'package:meta/meta.dart';

part 'course_event.dart';

part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(InitialCourseState()) {
    on<FetchEvent>((event, emit) async {
      await _fetchCourse(event, emit, event.courseId);
    });

    on<DeleteFromFavorite>((event, emit) async {
      try {
        await _coursesRepository.deleteFavoriteCourse(event.courseId);
        await _fetchCourse(event, emit, event.courseId);
      } catch (e, s) {
        logger.e('Error with addFavoriteCourse', e, s);
      }
      await _fetchCourse(event, emit, event.courseId);
    });

    on<AddToFavorite>((event, emit) async {
      try {
        await _coursesRepository.addFavoriteCourse(event.courseId);
        await _fetchCourse(event, emit, event.courseId);
      } catch (e, s) {
        logger.e('Error with addFavoriteCourse', e, s);
      }
    });

    on<PaymentSelectedEvent>((event, emit) {
      selectedPaymentId = event.selectedPaymentId;
    });

    on<UsePlan>((event, emit) async {
      emit(InitialCourseState());
      await _purchaseRepository.usePlan(event.courseId, selectedPaymentId);

      await _fetchCourse(event, emit, event.courseId);
    });

    on<AddToCart>((event, emit) async {
      final response = await _purchaseRepository.addToCart(event.courseId);
      emit(OpenPurchaseState(response.cartUrl));
    });

    on<GetTokenToCourse>((event, emit) async {
      emit(LoadingGetTokenToCourseState());
      try {
        final response = await _coursesRepository.getTokenToCourse(event.courseId);

        if (await isAuth() == false) {
          emit(ErrorGetTokenToCourseState('Token is empty'));
        } else {
          emit(SuccessGetTokenToCourseState(response.tokenAuth!));
        }
      } catch (e, s) {
        logger.e('Error getTokenToCourse', e, s);
        emit(ErrorGetTokenToCourseState(e.toString()));
      }
    });
  }

  final CoursesRepository _coursesRepository = CoursesRepositoryImpl();
  final ReviewRepository _reviewRepository = ReviewRepositoryImpl();
  final PurchaseRepository _purchaseRepository = PurchaseRepositoryImpl();
  CourseDetailResponse? courseDetailResponse;
  List<AllPlansBean> availablePlans = [];

  // if payment id is -1, selected type is one time payment
  int selectedPaymentId = -1;
  int _countTab = 2;

  int get countTab => _countTab;

  Future<CourseState> _fetchCourse(CourseEvent event, Emitter emit, int courseId) async {
    emit(InitialCourseState());
    _countTab = 2;
    try {
      courseDetailResponse = await _coursesRepository.getCourse(courseId);

      if (courseDetailResponse!.faq != null && courseDetailResponse!.faq!.isNotEmpty) {
        _countTab = 3;
      }

      var reviews = await _reviewRepository.getReviews(courseId);

      // var plans = await _purchaseRepository.getUserPlans(courseId);

      availablePlans = await _purchaseRepository.getPlans(courseId: courseId);

      emit(
        LoadedCourseState(
          courseDetailResponse!,
          reviews, /*userPlans: plans*/
        ),
      );
    } catch (e, s) {
      logger.e('Error courseDetailBloc', e, s);
      emit(ErrorCourseState(''));
    }
    return ErrorCourseState('');
  }
}
