import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/book.dart';

class LocalBookRepository {
  LocalBookRepository({this.boxName = 'books'});

  final String boxName;
  Box<Book>? _box;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BookAdapter());
    }
    await Hive.initFlutter();
    _box ??= await Hive.openBox<Book>(boxName);
  }

  Future<List<Book>> getAll() async {
    await init();
    return _box!.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Stream<List<Book>> watchAll() {
    return Stream.fromFuture(getAll()).asyncExpand((initial) {
      return _ensureBox().asyncExpand((_) {
        return _box!.watch().map((_) => _box!.values.toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)));
      }).startWith(initial);
    });
  }

  Future<Book?> getById(String id) async {
    await init();
    return _box!.get(id);
  }

  Future<void> upsert(Book book) async {
    await init();
    await _box!.put(book.id, book);
  }

  Future<void> upsertMany(List<Book> books) async {
    await init();
    await _box!.putAll({for (final book in books) book.id: book});
  }

  Future<void> delete(String id) async {
    await init();
    await _box!.delete(id);
  }

  Future<void> replaceAll(List<Book> books) async {
    await init();
    await _box!.clear();
    await upsertMany(books);
  }

  Future<void> clear() async {
    await init();
    await _box!.clear();
  }

  Stream<Box<Book>> _ensureBox() async* {
    await init();
    yield _box!;
  }
}

extension _StartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
