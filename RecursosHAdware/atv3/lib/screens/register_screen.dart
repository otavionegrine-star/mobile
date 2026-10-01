import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

// Tela de cadastro de novos usuários
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Executa o cadastro do usuário
  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(
      _identifierController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  // Campo de identificador (NIF ou E-mail)
  Widget _buildIdentifierField() {
    return TextFormField(
      controller: _identifierController,
      decoration: const InputDecoration(
        labelText: 'NIF ou E-mail',
        prefixIcon: Icon(Icons.person_add),
        border: OutlineInputBorder(),
      ),
      validator: (v) => v!.trim().isEmpty ? 'Informe o NIF ou E-mail' : null,
    );
  }

  // Campo de senha
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Senha (mínimo 6 caracteres)',
        prefixIcon: Icon(Icons.lock_outline),
        border: OutlineInputBorder(),
      ),
      validator: (v) => (v == null || v.length < 6)
          ? 'A senha deve ter pelo menos 6 caracteres'
          : null,
    );
  }

  // Campo de confirmação de senha
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Confirmar Senha',
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(),
      ),
      validator: (v) => v != _passwordController.text
          ? 'As senhas não coincidem'
          : null,
    );
  }

  // Botão de submissão do formulário
  Widget _buildSubmitButton(AuthProvider authProvider) {
    if (authProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ElevatedButton(
      onPressed: _submitRegister,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('CADASTRAR', style: TextStyle(fontSize: 16)),
    );
  }

  // Exibe mensagem de erro se houver
  Widget _buildErrorMessage(String? message) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Novo Cadastro')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person_add_alt_1, size: 70, color: Colors.blue),
                const SizedBox(height: 24),
                _buildIdentifierField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 24),
                _buildErrorMessage(authProvider.errorMessage),
                _buildSubmitButton(authProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

