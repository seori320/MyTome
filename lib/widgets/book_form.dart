import 'package:flutter/material.dart';

import '../models/book.dart';

class BookForm extends StatefulWidget {
  const BookForm({
    super.key,
    this.initialBook,
    required this.onSubmit,
    required this.submitLabel,
    this.isSaving = false,
  });

  final Book? initialBook;
  final ValueChanged<Book> onSubmit;
  final String submitLabel;
  final bool isSaving;

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagsController;

  @override
  void initState() {
    super.initState();
    final book = widget.initialBook;
    _titleController = TextEditingController(text: book?.title ?? '');
    _authorController = TextEditingController(text: book?.author ?? '');
    _descriptionController =
        TextEditingController(text: book?.description ?? '');
    _tagsController = TextEditingController(text: book?.tags.join(', ') ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final base = widget.initialBook ?? Book.empty();
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
      tags: tags,
    );

    widget.onSubmit(payload);
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.isSaving,
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
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: widget.isSaving ? null : _submit,
              icon: widget.isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(widget.submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}
