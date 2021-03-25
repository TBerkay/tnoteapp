import 'package:flutter/material.dart';
import 'package:tnoteapp/screens/note_list_screen.dart';
import 'package:tnoteapp/screens/note_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.brown),
      home: NoteListScreen(),
      routes: {
        "/noteListScreen":(BuildContext context) => NoteListScreen()
      },
    );
  }
}