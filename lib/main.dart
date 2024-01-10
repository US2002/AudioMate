import 'package:AudioMate/permissionChecker.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Assistant',
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
      home: const permissionChecker(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (_) => const HomePage(),
      },
    );
  }
}
