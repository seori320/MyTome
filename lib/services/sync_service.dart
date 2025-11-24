import '../models/book.dart';
import '../repositories/local_book_repository.dart';
import '../repositories/remote_book_repository.dart';

class SyncService {
  SyncService({
    required LocalBookRepository localRepository,
    required RemoteBookRepository remoteRepository,
  })  : _localRepository = localRepository,
        _remoteRepository = remoteRepository;

  final LocalBookRepository _localRepository;
  final RemoteBookRepository _remoteRepository;

  Future<void> initialize() async {
    await _localRepository.init();
    await syncFromRemote();
  }

  Future<void> syncFromRemote() async {
    final remoteBooks = await _remoteRepository.fetchAll();
    final localBooks = await _localRepository.getAll();
    final localById = {for (final book in localBooks) book.id: book};

    final merged = <Book>[];
    for (final remote in remoteBooks) {
      final local = localById[remote.id];
      if (local == null || remote.updatedAt.isAfter(local.updatedAt)) {
        merged.add(remote);
      } else {
        merged.add(local);
      }
      localById.remove(remote.id);
    }

    merged.addAll(localById.values);
    await _localRepository.replaceAll(merged);
  }

  Future<void> pushLocalChanges() async {
    final localBooks = await _localRepository.getAll();
    for (final book in localBooks) {
      await _remoteRepository.push(book);
    }
  }
}
