import '../entities/book.dart';
import '../repositories/book_repository.dart';

class DeleteBook {
  final BookRepository repository;

  DeleteBook(this.repository);

  Future<void> call(Book book) {
    return repository.deleteBook(book);
  }
}
