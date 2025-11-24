<<<<<<< HEAD
<<<<<<< HEAD
import 'package:flutter/material.dart';

import 'models/book.dart';
import 'screens/book_detail.dart';
import 'screens/book_form.dart';
import 'screens/book_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyTomeApp());
}

class MyTomeApp extends StatelessWidget {
  const MyTomeApp({super.key});
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
>>>>>>> c7d6be6a991323bdcd66709b7c0ff3ed573369b5

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'MyTome',
=======
      title: 'My Tome',
>>>>>>> c7d6be6a991323bdcd66709b7c0ff3ed573369b5
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
<<<<<<< HEAD
      initialRoute: BookListScreen.routeName,
      onGenerateRoute: (settings) {
        if (settings.name == BookFormScreen.routeName) {
          final book = settings.arguments as Book?;
          return MaterialPageRoute<Book?>(
            builder: (_) => BookFormScreen(book: book),
          );
        }
        if (settings.name == BookDetailScreen.routeName) {
          final book = settings.arguments as Book;
          return MaterialPageRoute<void>(
            builder: (_) => BookDetailScreen(book: book),
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => const BookListScreen(),
        );
      },
=======
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  User? _user;
  late final FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((user) {
      if (!mounted) return;
      setState(() => _user = user);
    });
  }

  Future<void> _signInAnonymously() async {
    await _auth.signInAnonymously();
  }

  Future<void> _addSampleNote() async {
    final user = _user;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(user.uid)
        .set({'createdAt': FieldValue.serverTimestamp(), 'content': 'Hello Firebase!'});
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Tome'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _signInAnonymously,
            child: const Text('Sign in anonymously'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tome'),
        actions: [
          IconButton(
            onPressed: () => _auth.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signed in as: ' + (_user?.uid ?? '')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addSampleNote,
              child: const Text('Create sample note'),
            ),
          ],
        ),
      ),
>>>>>>> c7d6be6a991323bdcd66709b7c0ff3ed573369b5
=======
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
>>>>>>> 652928c0213b4284ebf349589dd4187ac5674b9b
    );
  }
}
