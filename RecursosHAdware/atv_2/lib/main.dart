import 'package:flutter/material.dart';
import 'screens/checkin_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SenaiCheckInApp());
}

class SenaiCheckInApp extends StatelessWidget {
  const SenaiCheckInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENAI CheckIn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005CA9), // Azul SENAI
          primary: const Color(0xFF005CA9),
        ),
        useMaterial3: true,
      ),
      home: const CheckInListScreen(),
    );
  }
}