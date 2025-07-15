import 'package:book_finder_app/data/domain/entities/book.dart';
import 'package:book_finder_app/data/domain/repositories/book_repository.dart';


class GetBooksByQuery {
  final BookRepository repository;

  GetBooksByQuery(this.repository);

  Future<List<Book>> call(String query, int page) {
    return repository.searchBooks(query, page);
  }
}
