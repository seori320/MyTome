import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
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
    );
  }

  final String id;
  final String title;
  final String author;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toDocument() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
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
  }
}
