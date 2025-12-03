import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_repository.dart';
import '../widgets/book_form.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  static const routeName = '/add-book';

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final BookRepository _repository = BookRepository();
  bool _isSaving = false;

  Future<void> _handleSubmit(Book book) async {
    setState(() {
      _isSaving = true;
    });

    try {
      final result = await _repository.create(book);
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('책 정보를 저장할 수 없습니다. 다시 시도해주세요.\n$error'),
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
        title: const Text('책 추가하기'),
      ),
      body: BookForm(
        onSubmit: _handleSubmit,
        submitLabel: '저장',
        isSaving: _isSaving,
      ),
    );
  }
}
