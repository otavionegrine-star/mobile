// Gerencia o fluxo inicial conforme o estado de autenticação
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: AuthService().userChanges,
      builder: (context, snapshot) {
        final current = AuthService().currentUser;
        if (current != null || snapshot.data != null) {
          return const HomeScreen();
        }
        return const WelcomeScreen();
      },
    );
  }
}
