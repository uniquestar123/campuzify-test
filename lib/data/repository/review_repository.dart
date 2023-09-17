import 'package:masterstudy_app/data/datasources/reviews_datasource.dart';
import 'package:masterstudy_app/data/models/review/review_response.dart';
import 'package:masterstudy_app/data/models/review_add/review_add_response.dart';

abstract class ReviewRepository {
  Future<ReviewResponse> getReviews(int id);

  Future<ReviewAddResponse> addReview(int id, int mark, String review);
}

class ReviewRepositoryImpl extends ReviewRepository {
  final ReviewsDataSource _reviewsDataSource = ReviewRemoteDataSource();

  @override
  Future<ReviewResponse> getReviews(int id) async => await _reviewsDataSource.getReviews(id);

  @override
  Future<ReviewAddResponse> addReview(int id, int mark, String review) async =>
      await _reviewsDataSource.addReviews(id, mark, review);
}
