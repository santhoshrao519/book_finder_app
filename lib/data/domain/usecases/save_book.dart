import '../entities/book.dart';
import '../repositories/book_repository.dart';

class SaveBook {
  final BookRepository repository;

  SaveBook(this.repository);

  Future<void> call(Book book) async {
    return repository.saveBook(book);
  }
}
