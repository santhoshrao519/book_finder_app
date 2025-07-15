import 'package:book_finder_app/core/network/dio_client.dart';
import 'package:book_finder_app/data/models/book_model.dart';
import 'package:dio/dio.dart';
import 'package:book_finder_app/core/network/network_exception_handler.dart';


class BookApiService {
  final Dio dio = DioClient().dio;

  Future<List<BookModel>> searchBooks(String query, int page) async {
    try {
      final response = await dio.get(
        'search.json',
        queryParameters: {'q': query, 'page': page},
      );
      final docs = response.data['docs'] as List;
      return docs.map((e) => BookModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw NetworkExceptionHandler.handle(e);
    }
  }
}
