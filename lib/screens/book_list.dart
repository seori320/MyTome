import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_repository.dart';
import 'add_book_screen.dart';
import 'book_detail.dart';
import 'edit_book_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  static const routeName = '/';

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookRepository _repository = BookRepository();
  String? _selectedTag;

  Future<void> _addBook() async {
    final result = await Navigator.of(context).pushNamed<Book?>(
      AddBookScreen.routeName,
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('새 책이 추가되었습니다.'),
        ),
      );
    }
  }

  Future<void> _editBook(Book book) async {
    final result = await Navigator.of(context).pushNamed<Book?>(
      EditBookScreen.routeName,
      arguments: book,
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('책 정보가 업데이트되었습니다.'),
        ),
      );
    }
  }

  void _openDetail(Book book) {
    Navigator.of(context).pushNamed(
      BookDetailScreen.routeName,
      arguments: book,
    );
  }

  Widget _buildFilters(List<Book> books) {
    final tags = books.expand((book) => book.tags).toSet().toList()..sort();
    if (tags.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text('태그를 추가해 필터링을 활용해보세요.'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8,
        children: [
          FilterChip(
            label: const Text('전체'),
            selected: _selectedTag == null,
            onSelected: (_) => setState(() => _selectedTag = null),
          ),
          ...tags.map(
            (tag) => FilterChip(
              label: Text(tag),
              selected: _selectedTag == tag,
              onSelected: (_) => setState(() => _selectedTag = tag),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Book> books) {
    final filteredBooks = _selectedTag == null
        ? books
        : books.where((book) => book.tags.contains(_selectedTag)).toList();

    if (filteredBooks.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    _selectedTag == null
                        ? '등록된 책이 없습니다.\n플로팅 버튼을 눌러 책을 추가해보세요!'
                        : '선택한 태그에 해당하는 책이 없습니다.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      itemBuilder: (context, index) {
        final book = filteredBooks[index];
        return ListTile(
          leading: Icon(
            book.isCompleted
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: book.isCompleted ? Colors.green : Colors.grey,
          ),
          title: Text(book.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book.author),
              if (book.tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 2,
                    children: book.tags
                        .map(
                          (tag) => Chip(
                            padding: EdgeInsets.zero,
                            labelStyle: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontSize: 11),
                            label: Text(tag),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _editBook(book),
          ),
          onTap: () => _openDetail(book),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemCount: filteredBooks.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTome'),
        actions: [
          IconButton(
            onPressed: () => _addBook(),
            icon: const Icon(Icons.add),
            tooltip: '책 추가',
          ),
        ],
      ),
      body: StreamBuilder<List<Book>>(
        stream: _repository.watchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '책 목록을 불러오는 중 오류가 발생했습니다.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final books = snapshot.data ?? <Book>[];
          return Column(
            children: [
              _buildFilters(books),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // Force a fetch by waiting for the next stream event.
                    await _repository.watchBooks().first;
                  },
                  child: _buildList(books),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addBook(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
