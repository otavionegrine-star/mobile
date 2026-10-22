// Tela de cadastro reproduzindo o design system do Chef's Shelf
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _auth = AuthService();
  bool _termsAccepted = true;
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  // Validação dos dados informados
  bool _validate() {
    if (_email.text.trim().isEmpty || _password.text.length < 6) {
      _showMessage('A senha deve ter no mínimo 6 caracteres.');
      return false;
    }
    if (_password.text != _confirmPassword.text) {
      _showMessage('As senhas não coincidem.');
      return false;
    }
    if (!_termsAccepted) {
      _showMessage('Aceite os Termos de Uso para continuar.');
      return false;
    }
    return true;
  }

  // Registra novo usuário
  Future<void> _register() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    try {
      await _auth.register(_email.text, _password.text);
      if (mounted) {
        _showMessage('Conta criada com sucesso!');
        Navigator.popUntil(context, (r) => r.isFirst);
      }
    } catch (_) {
      if (mounted) _showMessage('Não foi possível criar a conta.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Exibe mensagem de feedback via SnackBar
  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Constrói cabeçalho com badges e título
  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant.withAlpha(60)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_fire_department, size: 16, color: AppColors.tertiaryContainer),
              SizedBox(width: 4),
              Text('Experiência Culinária Premium', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.tertiary)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text('Crie sua conta 🍳', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        const SizedBox(height: 4),
        const Text('Comece seu caderno digital e descubra pratos incríveis todos os dias.', style: TextStyle(fontSize: 13, color: AppColors.secondary)),
      ],
    );
  }

  // Constrói campos de entrada do formulário
  Widget _buildFields() {
    return Column(
      children: [
        TextField(
          controller: _name,
          decoration: const InputDecoration(labelText: 'Nome completo', prefixIcon: Icon(Icons.person_outline, size: 20)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.mail_outline, size: 20)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _password,
          obscureText: _obscure,
          decoration: InputDecoration(
            labelText: 'Senha (mínimo 6 caracteres)',
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _confirmPassword,
          obscureText: _obscure,
          decoration: const InputDecoration(labelText: 'Confirmar Senha', prefixIcon: Icon(Icons.lock_reset, size: 20)),
        ),
      ],
    );
  }

  // Constrói o cartão de segurança do Firestore
  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surfaceContainer,
            child: Icon(Icons.shield, size: 20, color: AppColors.tertiaryContainer),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Proteção em Nuvem', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                Text('Seus dados protegidos pelo Firebase Cloud Firestore', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Constrói indicador de etapas da AppBar
  Widget _buildStepIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 24, height: 6, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Container(width: 24, height: 6, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Container(width: 8, height: 6, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(3))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildStepIndicator(),
        actions: const [Padding(padding: EdgeInsets.only(right: 14), child: Icon(Icons.help_outline))],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopSection(),
              const SizedBox(height: 18),
              _buildFields(),
              const SizedBox(height: 10),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _termsAccepted,
                onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                title: const Text('Concordo com os Termos de Uso e Política de Privacidade da Chef’s Shelf.', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: _loading ? null : _register,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Criar conta'),
              ),
              const SizedBox(height: 18),
              _buildSecurityCard(),
              const SizedBox(height: 14),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: const Text('Já possui uma conta? Entrar', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
