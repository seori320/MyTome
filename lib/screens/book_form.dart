import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_repository.dart';

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key, this.book});

  static const routeName = '/book-form';

  final Book? book;

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagsController;
  late bool _isCompleted;
  bool _isSaving = false;

  final BookRepository _repository = BookRepository();

  @override
  void initState() {
    super.initState();
    final book = widget.book;
    _titleController = TextEditingController(text: book?.title ?? '');
    _authorController = TextEditingController(text: book?.author ?? '');
    _descriptionController =
        TextEditingController(text: book?.description ?? '');
    _tagsController =
        TextEditingController(text: book?.tags.join(', ') ?? '');
    _isCompleted = book?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() {
      _isSaving = true;
    });

    final base = widget.book ?? Book.empty();
    final tags = _tagsController.text
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();
    final payload = base.copyWith(
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      description: _descriptionController.text.trim(),
      isCompleted: _isCompleted,
      tags: tags,
    );

    try {
      Book result;
      if (widget.book == null) {
        result = await _repository.create(payload);
      } else {
        await _repository.update(payload);
        result = payload;
      }
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } on Object catch (error) {
      if (!mounted) {
        return;
      }
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
    final isEditing = widget.book != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '책 수정하기' : '책 추가하기'),
      ),
      body: AbsorbPointer(
        absorbing: _isSaving,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  hintText: '책 제목을 입력하세요',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '제목은 필수입니다.';
                  }
                  if (value.trim().length < 2) {
                    return '제목은 2글자 이상이어야 합니다.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: '저자',
                  hintText: '저자를 입력하세요',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '저자는 필수입니다.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: '태그',
                  hintText: '쉼표로 구분하여 태그를 입력하세요 (예: 판타지, 소설)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '설명',
                  alignLabelWithHint: true,
                ),
                minLines: 4,
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '책 설명을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                value: _isCompleted,
                onChanged: (value) => setState(() => _isCompleted = value),
                title: const Text('읽기 완료'),
                subtitle: const Text('책을 이미 다 읽었다면 켜주세요'),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _isSaving ? null : _submit,
                icon: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(isEditing ? '수정 완료' : '저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
