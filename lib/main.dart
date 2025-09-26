import 'package:flutter/material.dart';
import 'package:wf06/screens/my_diary_screen.dart'; // import หน้า My Diary
import 'package:wf06/screens/add_note_screen.dart'; // import หน้า Add Note

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Diary App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyDiaryScreen(),
        '/add_note': (context) => const AddNoteScreen(),
      },
    );
  }
}