import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/user_preferences.dart';
import '../services/book_repository.dart';
import 'edit_book_screen.dart';
import '../widgets/reader_controls.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({super.key, required this.book});

  static const routeName = '/book-detail';

  final Book book;

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final BookRepository _repository = BookRepository();
  late Book _book;
  UserPreferences? _preferences;
  bool _isReadingMode = false;

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    _loadPreferences();
  }

  Future<void> _editBook() async {
    final updated = await Navigator.of(context).pushNamed<Book?>(
      EditBookScreen.routeName,
      arguments: _book,
    );
    if (updated != null) {
      setState(() {
        _book = updated;
      });
    }
  }

  Future<void> _loadPreferences() async {
    final loaded = await UserPreferences.load();
    if (mounted) {
      setState(() {
        _preferences = loaded;
      });
    }
  }

  Future<void> _updatePreferences(UserPreferences preferences) async {
    await preferences.save();
    if (mounted) {
      setState(() {
        _preferences = preferences;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferences = _preferences;
    if (preferences == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return StreamBuilder<Book?>(
      stream: _repository.watchBook(_book.id),
      builder: (context, snapshot) {
        final latest = snapshot.data;
        if (latest != null && latest != _book) {
          _book = latest;
        }
        if (snapshot.connectionState == ConnectionState.waiting &&
            latest == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(_book.title)),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('책 정보를 불러오는 중 오류가 발생했습니다.\n${snapshot.error}'),
              ),
            ),
          );
        }
        if (latest == null) {
          return Scaffold(
            appBar: AppBar(title: Text(_book.title)),
            body: const Center(
              child: Text('이 책은 더 이상 존재하지 않습니다.'),
            ),
          );
        }

        final theme = Theme.of(context);
        final backgroundColor = _isReadingMode
            ? (preferences.useDarkTheme
                ? Colors.grey.shade900
                : theme.colorScheme.surfaceVariant)
            : theme.colorScheme.background;
        final textColor = _isReadingMode && preferences.useDarkTheme
            ? Colors.white
            : theme.colorScheme.onBackground;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(latest.title),
            backgroundColor: _isReadingMode
                ? backgroundColor
                : theme.appBarTheme.backgroundColor,
            foregroundColor: _isReadingMode && preferences.useDarkTheme
                ? Colors.white
                : null,
            actions: [
              IconButton(
                tooltip: _isReadingMode ? '일반 모드로' : '읽기 모드',
                onPressed: () {
                  setState(() {
                    _isReadingMode = !_isReadingMode;
                  });
                },
                icon: Icon(
                  _isReadingMode
                      ? Icons.close_fullscreen
                      : Icons.chrome_reader_mode,
                ),
              ),
              IconButton(
                tooltip: '편집',
                onPressed: _editBook,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          body: SafeArea(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(_isReadingMode ? 24 : 16),
              child: SingleChildScrollView(
                child: DefaultTextStyle(
                  style: theme.textTheme.bodyLarge!.copyWith(
                    height: 1.5,
                    fontSize: _isReadingMode ? preferences.fontSize : null,
                    color: textColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        latest.title,
                        style: theme.textTheme.headlineMedium!.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '저자: ${latest.author}',
                        style: theme.textTheme.titleMedium!
                            .copyWith(color: textColor),
                      ),
                      if (latest.tags.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: latest.tags
                              .map(
                                (tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text(latest.description),
                      const SizedBox(height: 24),
                      if (!_isReadingMode)
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              '등록일: ${_formatDate(latest.createdAt)}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: _isReadingMode
              ? ReaderControls(
                  preferences: preferences,
                  onChanged: _updatePreferences,
                )
              : null,
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
