import 'package:book_finder_app/data/datasources/local/book_db_helper.dart';
import 'package:book_finder_app/data/datasources/remote/book_api_service.dart';
import 'package:book_finder_app/data/domain/repositories/book_repository.dart';
import 'package:book_finder_app/data/domain/usecases/delete_book.dart';
import 'package:book_finder_app/data/domain/usecases/get_saved_books.dart';
import 'package:book_finder_app/data/domain/usecases/save_book.dart';
import 'package:book_finder_app/data/repositories/book_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_books_by_query.dart';

// ----------------------
// Repository Provider
// ----------------------
final repositoryProvider = Provider<BookRepository>((ref) {
  return BookRepositoryImpl(
    apiService: BookApiService(),
    dbHelper: BookDbHelper(),
  );
});
// ----------------------
// UseCase Providers
// ----------------------
final getBooksUsecaseProvider = Provider<GetBooksByQuery>((ref) {
  return GetBooksByQuery(ref.read(repositoryProvider));
});

final saveBookUsecaseProvider = Provider<SaveBook>((ref) {
  return SaveBook(ref.read(repositoryProvider));
});

final getSavedBooksUsecaseProvider = Provider<GetSavedBooks>((ref) {
  return GetSavedBooks(ref.read(repositoryProvider));
});

final deleteBookUsecaseProvider = Provider((ref) {
  return DeleteBook(ref.watch(repositoryProvider));
});


// ----------------------
// Book Notifier & Provider
// ----------------------
final bookProvider = StateNotifierProvider<BookNotifier, AsyncValue<List<Book>>>((ref) {
  final usecase = ref.read(getBooksUsecaseProvider);
  return BookNotifier(usecase);
});

class BookNotifier extends StateNotifier<AsyncValue<List<Book>>> {
  final GetBooksByQuery _getBooks;

  BookNotifier(this._getBooks) : super(const AsyncValue.data([]));

  Future<void> search(String query, int page) async {
    state = const AsyncLoading();
    try {
      final books = await _getBooks(query, page);
      state = AsyncData(books);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
