import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/book.dart';
import 'screens/book_detail.dart';
import 'screens/book_form.dart';
import 'screens/book_list.dart';

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
    );
  }
}
