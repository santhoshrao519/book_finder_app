import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_saved_books.dart';
import '../../domain/usecases/delete_book.dart';
import 'book_provider.dart';
final savedBooksProvider =
    StateNotifierProvider<SavedBooksNotifier, AsyncValue<List<Book>>>((ref) {
  final getSaved = ref.read(getSavedBooksUsecaseProvider);
  final delete = ref.read(deleteBookUsecaseProvider);
  return SavedBooksNotifier(getSavedBooks: getSaved, deleteBook: delete);
});

class SavedBooksNotifier extends StateNotifier<AsyncValue<List<Book>>> {
  final GetSavedBooks getSavedBooks;
  final DeleteBook deleteBook;

  SavedBooksNotifier({
    required this.getSavedBooks,
    required this.deleteBook,
  }) : super(const AsyncLoading()) {
    loadBooks();
  }

  Future<void> loadBooks() async {
    state = const AsyncLoading();
    try {
      final books = await getSavedBooks();
      state = AsyncData(books);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> removeBook(Book book) async {
    await deleteBook(book);
    await loadBooks(); // ✅ auto-refresh after delete
  }
}
