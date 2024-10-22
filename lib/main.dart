import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:math_notes_gdsc_workshop/presentation/home_page.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Notes',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      builder: (context, child) => LoaderOverlay(child: child ?? Container()),
      home: const HomePage(),
    );
  }
}
