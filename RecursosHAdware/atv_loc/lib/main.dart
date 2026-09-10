import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const ClimaLocalApp());
}

class ClimaLocalApp extends StatelessWidget {
  const ClimaLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima Local',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}