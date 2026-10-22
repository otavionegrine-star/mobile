// Ponto de entrada principal do aplicativo Chef's Shelf
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/auth_gate.dart';
import 'theme/app_theme.dart';

void main() async {
  // Garante a inicialização das bindings do Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Conecta a aplicação ao serviço do Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// Widget raiz da aplicação com tema visual personalizado
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chef's Shelf",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}
