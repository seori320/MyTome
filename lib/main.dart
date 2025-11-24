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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
    );
  }
}
