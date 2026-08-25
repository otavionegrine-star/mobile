import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegistering = true;
  String? _error;

  Future<void> _login() async {
    final name = _nameController.text.trim();
    final password = _passwordController.text;
    if (name.isEmpty || password.length < 4) {
      setState(() => _error = 'Informe o nome e uma senha com pelo menos 4 caracteres.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final accounts = prefs.getStringList('accounts') ?? [];
    final accountIndex = accounts.indexWhere((account) => account.startsWith('$name|'));

    if (_isRegistering) {
      if (accountIndex >= 0) {
        setState(() => _error = 'Esse usuário já possui uma conta.');
        return;
      }
      accounts.add('$name|$password');
      await prefs.setStringList('accounts', accounts);
    } else if (accountIndex < 0 || accounts[accountIndex] != '$name|$password') {
      setState(() => _error = 'Nome ou senha inválidos.');
      return;
    }

    await prefs.setString('userName', name);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const goldAccent = Color(0xFFD4AF37);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.movie_filter_rounded,
                size: 90,
                color: goldAccent,
              ),
              const SizedBox(height: 12),
              const Text(
                'CineFavorite',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: goldAccent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Seu Nome',
                  prefixIcon: Icon(Icons.person_outline, color: goldAccent),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline, color: goldAccent),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: Text(_isRegistering ? 'CRIAR CONTA' : 'ENTRAR'),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _isRegistering = !_isRegistering;
                  _error = null;
                }),
                child: Text(
                  _isRegistering ? 'Já tenho uma conta' : 'Criar uma conta',
                  style: const TextStyle(color: goldAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}