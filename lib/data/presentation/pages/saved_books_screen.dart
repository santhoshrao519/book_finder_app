import 'package:book_finder_app/core/utils/snackbar_utils.dart';
import 'package:book_finder_app/data/presentation/widgets/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';
import '../../application/providers/saved_books_provider.dart';

class SavedBooksScreen extends ConsumerWidget {
  const SavedBooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savedBooksProvider);
    final notifier = ref.read(savedBooksProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Books')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (books) => books.isEmpty
            ? const Center(child: Text('No books saved yet.'))
            : ListView.separated(
                itemCount: books.length,
                itemBuilder: (_, index) {
                  final book = books[index];
                  return BookTile(
                    book: book,
                    onDelete: () async {
                      await notifier.removeBook(book);
                      SnackBarUtils.success(context, 'Book removed');

                    },
                    onTap: null, // no navigation for saved
                  );
                },
                separatorBuilder: (_, __) =>
                    const Divider(height: 0, thickness: 1),
              ),
      ),
    );
  }
}
