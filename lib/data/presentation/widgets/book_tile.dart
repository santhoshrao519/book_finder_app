import 'package:book_finder_app/data/presentation/pages/bookdetail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback? onDelete; // ✅ optional delete action
  final VoidCallback? onTap; // ✅ optional custom tap (for Saved tab)

  const BookTile({
    super.key,
    required this.book,
    this.onDelete,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: book.coverUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: book.coverUrl,
              width: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 50,
                  height: 70,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.book, size: 40),
            )
          : const Icon(Icons.book, size: 40),
      title: Text(book.title),
      subtitle: Text(book.author),
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailScreen(book: book),
          ),
        );
      },
    );
  }
}
