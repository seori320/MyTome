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
