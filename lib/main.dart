import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/local_book_repository.dart';
import 'repositories/remote_book_repository.dart';
import 'screens/reader_screen.dart';
import 'services/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final localRepository = LocalBookRepository();
  final remoteRepository = RemoteBookRepository();
  final syncService = SyncService(
    localRepository: localRepository,
    remoteRepository: remoteRepository,
  );

  await syncService.initialize();

  runApp(MyApp(
    localRepository: localRepository,
    remoteRepository: remoteRepository,
    syncService: syncService,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.localRepository,
    required this.remoteRepository,
    required this.syncService,
  });

  final LocalBookRepository localRepository;
  final RemoteBookRepository remoteRepository;
  final SyncService syncService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: localRepository),
        Provider.value(value: remoteRepository),
        Provider.value(value: syncService),
      ],
      child: MaterialApp(
        title: 'MyTome',
        theme: ThemeData.light(),
        home: const ReaderScreen(),
      ),
    );
  }
}
