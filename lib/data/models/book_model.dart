import 'package:book_finder_app/data/domain/entities/book.dart';

class BookModel extends Book {
  BookModel({required super.title, required super.author, required super.coverUrl, required super.key});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'] ?? 'Unknown',
      author: (json['author_name'] != null && json['author_name'].isNotEmpty)
          ? json['author_name'][0]
          : 'Unknown',
      coverUrl: json['cover_i'] != null
          ? "https://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg"
          : '',
      key: json['key'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'coverUrl': coverUrl,
    'key': key,
  };

  factory BookModel.fromDb(Map<String, dynamic> map) => BookModel(
    title: map['title'],
    author: map['author'],
    coverUrl: map['coverUrl'],
    key: map['key'],
  );

  Map<String, dynamic> toDb() => toJson();
}