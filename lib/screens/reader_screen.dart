import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../repositories/local_book_repository.dart';
import '../services/sync_service.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late final LocalBookRepository _localRepository;
  late final SyncService _syncService;
  late Future<List<Book>> _initialLoad;

  @override
  void initState() {
    super.initState();
    _localRepository = context.read<LocalBookRepository>();
    _syncService = context.read<SyncService>();
    _initialLoad = _localRepository.getAll();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _syncService.syncFromRemote();
      if (mounted) {
        setState(() {
          _initialLoad = _localRepository.getAll();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await _syncService.syncFromRemote();
              if (mounted) {
                setState(() {
                  _initialLoad = _localRepository.getAll();
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: _initialLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data ?? [];

          if (books.isEmpty) {
            return const Center(
              child: Text('로컬 캐시에 저장된 책이 없습니다.'),
            );
          }

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text(
                  book.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  '${book.updatedAt.year}-${book.updatedAt.month.toString().padLeft(2, '0')}-${book.updatedAt.day.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
