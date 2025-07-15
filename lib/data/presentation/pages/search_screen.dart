import 'dart:async';
import 'package:book_finder_app/data/presentation/widgets/shimmerloader_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/book_provider.dart';
import '../widgets/book_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  int _page = 1;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = _controller.text.trim();
      if (query.length >= 3 && query != _lastQuery) {
        _lastQuery = query;
        _page = 1;
        ref.read(bookProvider.notifier).search(query, _page);
      }
    });
  }

  Future<void> _onRefresh() async {
    final query = _controller.text.trim();
    if (query.length >= 3) {
      _page = 1;
      await ref.read(bookProvider.notifier).search(query, _page);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Finder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search books...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: state.when(
              data: (books) => RefreshIndicator(
                onRefresh: _onRefresh,
                child: books.isEmpty
                    ? const Center(child: Text("No results found"))
                    : ListView.separated(
                        itemCount: books.length,
                        itemBuilder: (_, index) => BookTile(book: books[index]),
                        separatorBuilder: (_, __) =>
                            const Divider(height: 0, thickness: 1),
                      ),
              ),
              loading: () => ListView.builder(
                itemCount: 10,
                itemBuilder: (_, __) => const ShimmerLoadingTile(),
              ),
              error: (e, _) => Center(
                child: Text("Error: ${e.toString()}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
