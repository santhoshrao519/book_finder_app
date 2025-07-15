import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> searchBooks(String query, int page);
  Future<void> saveBook(Book book);
  Future<List<Book>> getSavedBooks();
  Future<void> deleteBook(Book book);

}
