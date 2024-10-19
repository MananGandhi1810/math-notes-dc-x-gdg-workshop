import 'package:flutter/material.dart';
import 'package:math_notes_gdsc_workshop/presentation/home_page.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
