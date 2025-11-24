import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 1)
class Book {
  Book({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime updatedAt;

  Book copyWith({
    String? title,
    String? content,
    DateTime? updatedAt,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
      id: data['id'] as String,
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      updatedAt: DateTime.parse(data['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
