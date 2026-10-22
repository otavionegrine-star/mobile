import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot){
        //Se o snapshot tem dados armazenado, significa que o usuário está logado
        if(snapshot.hasData) {
          return TarefasScreen();
        }
        // se não tiver dados de usuário armazenado
          return LoginScreen();
      });
  }
}