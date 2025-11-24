import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book.dart';

class RemoteBookRepository {
  RemoteBookRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('books');

  Future<List<Book>> fetchAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Book(
        id: doc.id,
        title: data['title'] as String? ?? '',
        content: data['content'] as String? ?? '',
        updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ??
            DateTime.fromMillisecondsSinceEpoch(0),
      );
    }).toList();
  }

  Future<void> push(Book book) async {
    await _collection.doc(book.id).set({
      'title': book.title,
      'content': book.content,
      'updatedAt': Timestamp.fromDate(book.updatedAt),
    }, SetOptions(merge: true));
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
