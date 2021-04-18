import 'package:bottle_tracker/entries_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottle Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EntriesScreen(title: 'Track Your Bottles'),
      debugShowCheckedModeBanner: false,
    );
  }
}
