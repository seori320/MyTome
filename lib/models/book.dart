import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 1)
class Book {
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.createdAt,
    DateTime? updatedAt,
    List<String>? tags,
  })  : updatedAt = updatedAt ?? createdAt,
        tags = tags ?? const <String>[];

  factory Book.empty() {
    final now = DateTime.now();
    return Book(
      id: '',
      title: '',
      author: '',
      description: '',
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
      description:
          data['description'] as String? ?? (data['content'] as String? ?? ''),
      createdAt: _asDateTime(data['createdAt']) ?? DateTime.now(),
      updatedAt: _asDateTime(data['updatedAt']) ?? DateTime.now(),
      tags: _asStringList(data['tags']),
    );
  }

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
      id: data['id'] as String? ?? '',
      title: data['title'] as String? ?? '',
      author: data['author'] as String? ?? '',
      description:
          data['description'] as String? ?? (data['content'] as String? ?? ''),
      createdAt: _asDateTime(data['createdAt']) ?? DateTime.now(),
      updatedAt: _asDateTime(data['updatedAt']) ?? DateTime.now(),
      tags: _asStringList(data['tags']),
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String description;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  @HiveField(7)
  final List<String> tags;

  String get content => description;

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? content ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toDocument() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'tags': tags,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
    };
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static List<String> _asStringList(dynamic value) {
    if (value is Iterable) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    return <String>[];
  }
}
