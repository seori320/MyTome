import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book.dart';

class BookRepository {
  BookRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('books');

  Stream<List<Book>> watchBooks() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(Book.fromSnapshot).toList(),
        );
  }

  Future<Book?> fetchBook(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) {
      return null;
    }
    return Book.fromSnapshot(doc);
  }

  Stream<Book?> watchBook(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return Book.fromSnapshot(snapshot);
    });
  }

  Future<Book> create(Book book) async {
    final payload = book.copyWith(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final docRef = await _collection.add(payload.toDocument());
    final doc = await docRef.get();
    return Book.fromSnapshot(doc);
  }

  Future<void> update(Book book) async {
    final updated = book.copyWith(updatedAt: DateTime.now());
    await _collection.doc(book.id).update(updated.toDocument());
  }

  Future<void> delete(String id) {
    return _collection.doc(id).delete();
  }
}
