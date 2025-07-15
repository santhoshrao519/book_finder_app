import 'package:book_finder_app/core/utils/snackbar_utils.dart';
import 'package:book_finder_app/data/application/providers/saved_books_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';
import '../../application/providers/book_provider.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  ConsumerState<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _rotation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

void _saveBook() async {
  final savedBooks = await ref.read(getSavedBooksUsecaseProvider).call();
  final alreadySaved = savedBooks.any((b) => b.key == widget.book.key);

  if (alreadySaved) {
    if (!mounted) return;
   SnackBarUtils.success(context, 'Book already saved!');

    return;
  }

  await ref.read(saveBookUsecaseProvider).call(widget.book);
  ref.invalidate(savedBooksProvider);

  if (!mounted) return;
  SnackBarUtils.success(context, 'Book saved successfully!');

  
}


@override
Widget build(BuildContext context) {
  final book = widget.book;
  final theme = Theme.of(context);
  final savedBooks = ref.watch(savedBooksProvider).maybeWhen(
    data: (books) => books,
    orElse: () => <Book>[],
  );
  final alreadySaved = savedBooks.any((b) => b.key == book.key);

  return Scaffold(
    appBar: AppBar(title: const Text('Book Details')),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: [
       Center(child: RotationTransition(
            turns: _rotation,
            child: Hero(
              tag: book.key,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: book.coverUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 120,
                    height: 180,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, size: 120),
                ),
              ),
            ),
       )),
          const SizedBox(height: 30),
          Text(
            book.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'by ${book.author}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Key: ${book.key}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: alreadySaved ? null : _saveBook,
            icon: Icon(alreadySaved ? Icons.check : Icons.save_alt),
            label: Text(alreadySaved ? 'Saved' : 'Save Book'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    ),
  );
}
}
