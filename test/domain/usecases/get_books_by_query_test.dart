import 'package:book_finder_app/data/domain/entities/book.dart';
import 'package:book_finder_app/data/domain/usecases/get_books_by_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_book_repository.mocks.dart';


void main() {
  late MockBookRepository mockRepository;
  late GetBooksByQuery usecase;

  setUp(() {
    mockRepository = MockBookRepository();
    usecase = GetBooksByQuery(mockRepository);
  });

  test('should return a list of books when called', () async {
    // Arrange
    final testBooks = [
      Book(title: 'Test Book', author: 'Tester', coverUrl: '', key: '123'),
    ];
    when(mockRepository.searchBooks('flutter', 1))
        .thenAnswer((_) async => testBooks);

    // Act
    final result = await usecase('flutter', 1);

    // Assert
    expect(result, testBooks);
    verify(mockRepository.searchBooks('flutter', 1)).called(1);
  });
}
