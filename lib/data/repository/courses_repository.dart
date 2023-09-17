import 'package:masterstudy_app/core/extensions/basic_extensions.dart';
import 'package:masterstudy_app/data/datasources/courses_datasource.dart';
import 'package:masterstudy_app/data/datasources/favorite_datasource.dart';
import 'package:masterstudy_app/data/datasources/user_course_datasource.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';
import 'package:masterstudy_app/data/models/course/courses_response.dart';
import 'package:masterstudy_app/data/models/popular_searches/popular_searches_response.dart';

enum Sort { free, date_low, price_low, price_high, rating, popular, favorite }

abstract class CoursesRepository {
  Future<CoursesResponse> getCourses({
    int perPage,
    int page,
    Sort sort,
    int authorId,
    int? categoryId,
    String? searchQuery,
  });

  Future<CoursesResponse> getFavoriteCourses();

  Future addFavoriteCourse(int courseId);

  Future deleteFavoriteCourse(int courseId);

  Future<CourseDetailResponse> getCourse(int courseId);

  Future<PopularSearchesResponse> getPopularSearches();

  Future<bool> verifyInApp(String serverVerificationData, String price);

  Future<TokenAuthToCourse> getTokenToCourse(int courseId);
}

class CoursesRepositoryImpl extends CoursesRepository {
  final UserCourseDataSource _userCourseDataSource = UserCourseRemoteDataSource();
  final CoursesDataSource _coursesDataSource = CoursesRemoteDataSource();
  final FavouriteDataSource _favouriteDataSource = FavouriteRemoteDataSource();

  @override
  Future<CoursesResponse> getCourses({
    int? perPage,
    int? page,
    Sort? sort,
    int? authorId,
    int? categoryId,
    String? searchQuery,
  }) {
    Map<String, dynamic> queryParams = {};

    queryParams.addParam('per_page', perPage);
    queryParams.addParam('page', page);
    queryParams.addParam('author_id', authorId);
    if (categoryId != null) {
      queryParams.addParam('category', categoryId);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams.addParam('s', searchQuery);
    }

    if (sort != null) {
      var sortValue;
      switch (sort) {
        case Sort.free:
          sortValue = 'free';
          break;
        case Sort.date_low:
          sortValue = 'date_low';
          break;
        case Sort.price_low:
          sortValue = 'price_low';
          break;
        case Sort.price_high:
          sortValue = 'price_high';
          break;
        case Sort.rating:
          sortValue = 'rating';
          break;
        case Sort.popular:
          sortValue = 'popular';
          break;
        case Sort.favorite:
          sortValue = 'favorite';
          break;
      }
      queryParams.addParam('sort', sortValue);
    }

    return _coursesDataSource.getCourses(queryParams);
  }

  @override
  Future<CoursesResponse> getFavoriteCourses() {
    return _favouriteDataSource.getFavoriteCourses();
  }

  @override
  Future addFavoriteCourse(int courseId) {
    return _favouriteDataSource.addFavoriteCourse(courseId);
  }

  @override
  Future deleteFavoriteCourse(int courseId) {
    return _favouriteDataSource.deleteFavoriteCourse(courseId);
  }

  @override
  Future<CourseDetailResponse> getCourse(int courseId) async => await _userCourseDataSource.getCourse(courseId);

  @override
  Future<PopularSearchesResponse> getPopularSearches() async => await _coursesDataSource.popularSearches(10);

  @override
  Future<bool> verifyInApp(String serverVerificationData, String price) async =>
      await _coursesDataSource.verifyInApp(serverVerificationData, price);

  @override
  Future<TokenAuthToCourse> getTokenToCourse(int courseId) async => await _coursesDataSource.getTokenToCourse(courseId);
}
