import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/book.dart';
import 'screens/add_book_screen.dart';
import 'screens/book_detail.dart';
import 'screens/book_list.dart';
import 'screens/edit_book_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyTomeApp());
}

class MyTomeApp extends StatelessWidget {
  const MyTomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: BookListScreen.routeName,
      onGenerateRoute: (settings) {
        if (settings.name == AddBookScreen.routeName) {
          return MaterialPageRoute<Book?>(
            builder: (_) => const AddBookScreen(),
          );
        }
        if (settings.name == EditBookScreen.routeName) {
          final book = settings.arguments as Book;
          return MaterialPageRoute<Book?>(
            builder: (_) => EditBookScreen(book: book),
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
    );
  }
}
