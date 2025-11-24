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
    return snapshot.docs.map(Book.fromSnapshot).toList();
  }

  Future<void> push(Book book) async {
    await _collection.doc(book.id).set(
          book.toDocument(),
          SetOptions(merge: true),
        );
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
