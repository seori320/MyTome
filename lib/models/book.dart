<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';

=======
import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 1)
>>>>>>> 652928c0213b4284ebf349589dd4187ac5674b9b
class Book {
  Book({
    required this.id,
    required this.title,
<<<<<<< HEAD
    required this.author,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
    this.tags = const <String>[],
  });

  factory Book.empty() {
    final now = DateTime.now();
    return Book(
      id: '',
      title: '',
      author: '',
      description: '',
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
      tags: const <String>[],
    );
  }

  factory Book.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Book(
      id: doc.id,
      title: data['title'] as String? ?? '',
      author: data['author'] as String? ?? '',
      description: data['description'] as String? ?? '',
      isCompleted: data['isCompleted'] as bool? ?? false,
      createdAt: _asDateTime(data['createdAt']) ?? DateTime.now(),
      updatedAt: _asDateTime(data['updatedAt']),
      tags: _asStringList(data['tags']),
    );
  }

  final String id;
  final String title;
  final String author;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> tags;

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
=======
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
>>>>>>> 652928c0213b4284ebf349589dd4187ac5674b9b
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }

<<<<<<< HEAD
  Map<String, dynamic> toDocument() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'tags': tags,
    }..removeWhere((_, value) => value == null);
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
=======
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
>>>>>>> 652928c0213b4284ebf349589dd4187ac5674b9b
  }

  static List<String> _asStringList(dynamic value) {
    if (value is Iterable) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    return <String>[];
  }
}
