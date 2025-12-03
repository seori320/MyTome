import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_repository.dart';
import '../widgets/book_form.dart';

class EditBookScreen extends StatefulWidget {
  const EditBookScreen({super.key, required this.book});

  static const routeName = '/edit-book';

  final Book book;

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final BookRepository _repository = BookRepository();
  bool _isSaving = false;

  Future<void> _handleSubmit(Book book) async {
    setState(() {
      _isSaving = true;
    });

    try {
      await _repository.update(book);
      if (mounted) {
        Navigator.of(context).pop(book);
      }
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('책 정보를 수정할 수 없습니다. 다시 시도해주세요.\n$error'),
        ),
      );
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('책 수정하기'),
      ),
      body: BookForm(
        initialBook: widget.book,
        onSubmit: _handleSubmit,
        submitLabel: '수정 완료',
        isSaving: _isSaving,
      ),
    );
  }
}
