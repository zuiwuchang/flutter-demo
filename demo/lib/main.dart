import 'package:flutter/material.dart';
import './home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData themeData;
    if (MediaQuery.platformBrightnessOf(context) == Brightness.dark) {
      themeData = ThemeData.dark(useMaterial3: true);
    } else {
      themeData = ThemeData.light(useMaterial3: true);
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: const MyHomePage(),
    );
  }
}
