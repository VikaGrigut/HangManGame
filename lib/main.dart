import 'package:flutter/material.dart';
import 'package:hang_man/pages/GamePage.dart';
import 'package:hang_man/pages/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/game': (context) => GamePage()
      },
    );
  }
}
