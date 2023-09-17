import 'package:dio/dio.dart';
import 'package:masterstudy_app/core/services/http_service.dart';
import 'package:masterstudy_app/data/models/review/review_response.dart';
import 'package:masterstudy_app/data/models/review_add/review_add_response.dart';

abstract class ReviewsDataSource {
  Future<ReviewResponse> getReviews(int id);

  Future<ReviewAddResponse> addReviews(int id, int mark, String review);
}

class ReviewRemoteDataSource extends ReviewsDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<ReviewResponse> getReviews(int id) async {
    try {
      Response response = await _httpService.dio.get(
        '/course_reviews',
        queryParameters: {'id': id},
      );
      return ReviewResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<ReviewAddResponse> addReviews(int id, int mark, String review) async {
    try {
      Response response = await _httpService.dio.put(
        '/course_reviews',
        queryParameters: {'id': id, 'mark': mark, 'review': review},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return ReviewAddResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
