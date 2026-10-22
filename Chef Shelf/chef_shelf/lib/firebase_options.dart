// Configurações do Firebase para a aplicação
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  // Retorna as opções da plataforma atual
  static FirebaseOptions get currentPlatform {
    return android;
  }

  // Configurações para plataforma Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-2LUJpCZNCurWpx5cA6O9Ar2DIyr5H7M',
    appId: '1:856754971836:android:6a161aaf02220b2df59cb9',
    messagingSenderId: '856754971836',
    projectId: 'lista-tarefa-firebase-otavio',
    storageBucket: 'lista-tarefa-firebase-otavio.firebasestorage.app',
  );
}

