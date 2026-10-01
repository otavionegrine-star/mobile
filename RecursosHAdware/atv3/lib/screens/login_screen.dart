import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'register_screen.dart';

// Tela principal de login do usuário
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Submete o login tradicional
  void _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.login(
      _identifierController.text,
      _passwordController.text,
    );

    if (ok && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  // Submete login via biometria
  void _submitBiometricLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.loginWithBiometrics();

    if (ok && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  // Navega para a tela de cadastro
  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  // Constrói os campos de texto do formulário
  List<Widget> _buildInputs() {
    return [
      TextFormField(
        controller: _identifierController,
        decoration: const InputDecoration(
          labelText: 'NIF ou E-mail',
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(),
        ),
        validator: (v) => v!.trim().isEmpty ? 'Informe o NIF ou E-mail' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Senha',
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? 'Informe a senha' : null,
      ),
    ];
  }

  // Constrói os botões de ação e cadastro
  List<Widget> _buildButtons(AuthProvider auth) {
    if (auth.isLoading) {
      return const [Center(child: CircularProgressIndicator())];
    }
    return [
      ElevatedButton(
        onPressed: _submitLogin,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('ENTRAR', style: TextStyle(fontSize: 16)),
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: _submitBiometricLogin,
        icon: const Icon(Icons.fingerprint, size: 28),
        label: const Text('Entrar com Biometria / Face ID'),
      ),
      const SizedBox(height: 12),
      TextButton(
        onPressed: _navigateToRegister,
        child: const Text('Não possui uma conta? Cadastre-se'),
      ),
    ];
  }

  // Constrói a mensagem de erro se existente
  Widget _buildError(String? msg) {
    if (msg == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        msg,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.access_time_filled, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'Registro de Ponto',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                ..._buildInputs(),
                const SizedBox(height: 16),
                _buildError(authProvider.errorMessage),
                ..._buildButtons(authProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }
}