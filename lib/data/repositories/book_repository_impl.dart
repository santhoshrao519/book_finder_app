import 'package:book_finder_app/data/datasources/local/book_db_helper.dart';
import 'package:book_finder_app/data/datasources/remote/book_api_service.dart';
import 'package:book_finder_app/data/domain/entities/book.dart';
import 'package:book_finder_app/data/domain/repositories/book_repository.dart';
import 'package:book_finder_app/data/domain/usecases/get_books_by_query.dart';
import 'package:book_finder_app/data/models/book_model.dart';

class BookRepositoryImpl implements BookRepository {
  final BookApiService apiService;
  final BookDbHelper dbHelper;

  BookRepositoryImpl({required this.apiService, required this.dbHelper});

  @override
  Future<List<Book>> searchBooks(String query, int page) => apiService.searchBooks(query, page);

  @override
  Future<void> saveBook(Book book) async => dbHelper.insertBook(BookModel(
    title: book.title,
    author: book.author,
    coverUrl: book.coverUrl,
    key: book.key,
  ));

  @override
  Future<List<Book>> getSavedBooks() async => dbHelper.getBooks();
  
  @override
Future<void> deleteBook(Book book) async {
  await dbHelper.deleteBookByKey(book.key);
}

}
