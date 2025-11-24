import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_repository.dart';
import 'book_detail.dart';
import 'book_form.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  static const routeName = '/';

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookRepository _repository = BookRepository();

  Future<void> _openForm({Book? book}) async {
    final result = await Navigator.of(context).pushNamed<Book?>(
      BookFormScreen.routeName,
      arguments: book,
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            book == null ? '새 책이 추가되었습니다.' : '책 정보가 업데이트되었습니다.',
          ),
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

  Widget _buildList(List<Book> books) {
    if (books.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    '등록된 책이 없습니다.\n플로팅 버튼을 눌러 책을 추가해보세요!',
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
        final book = books[index];
        return ListTile(
          leading: Icon(
            book.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: book.isCompleted ? Colors.green : Colors.grey,
          ),
          title: Text(book.title),
          subtitle: Text(book.author),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _openForm(book: book),
          ),
          onTap: () => _openDetail(book),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemCount: books.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTome'),
        actions: [
          IconButton(
            onPressed: () => _openForm(),
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
          return RefreshIndicator(
            onRefresh: () async {
              // Force a fetch by waiting for the next stream event.
              await _repository.watchBooks().first;
            },
            child: _buildList(books),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
