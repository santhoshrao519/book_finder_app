import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetSavedBooks {
  final BookRepository repository;

  GetSavedBooks(this.repository);

  Future<List<Book>> call() async {
    return repository.getSavedBooks();
  }
}
