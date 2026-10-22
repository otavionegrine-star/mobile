// Tela de login reproduzindo o design system do Chef's Shelf
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Executa login do usuário
  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await _auth.login(_email.text, _password.text);
      if (mounted) Navigator.popUntil(context, (r) => r.isFirst);
    } catch (_) {
      if (mounted) _showMessage('Não foi possível entrar. Confira seus dados.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Preenche conta de teste para acesso rápido
  void _fillDemo() {
    setState(() {
      _email.text = 'chef@chefshelf.com';
      _password.text = '123456';
    });
  }

  // Dispara recuperação de senha
  Future<void> _resetPassword() async {
    if (_email.text.trim().isEmpty) {
      _showMessage('Informe seu e-mail para recuperar a senha.');
      return;
    }
    await _auth.resetPassword(_email.text);
    if (mounted) _showMessage('Link enviado para o e-mail informado.');
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
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 14, color: AppColors.onPrimaryFixedVariant),
              SizedBox(width: 4),
              Text('Firebase Auth Sincronizado', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onPrimaryFixedVariant)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text('Bem-vindo de volta! 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        const SizedBox(height: 4),
        const Text('Entre para acessar seu caderno de receitas personalizadas.', style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  // Constrói banner contextual de sincronização
  Widget _buildSyncBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(60)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.secondaryContainer,
            child: Icon(Icons.cloud_sync, size: 18, color: AppColors.primaryContainer),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sincronização ativa', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text('Sessão anterior do seu caderno pronta para restauração.', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Constrói o formulário de login
  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.softGreen),
              backgroundColor: AppColors.surfaceContainerLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _fillDemo,
            icon: const Icon(Icons.key, size: 16, color: AppColors.primary),
            label: const Text('Preencher: chef@chefshelf.com', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 14),
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
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _resetPassword,
              child: const Text('Esqueci minha senha', style: TextStyle(fontSize: 12, color: AppColors.primary)),
            ),
          ),
          FilledButton.icon(
            onPressed: _loading ? null : _login,
            icon: _loading ? const SizedBox.shrink() : const Icon(Icons.arrow_forward, size: 18),
            label: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Entrar'),
          ),
        ],
      ),
    );
  }

  // Constrói pílula com receita de destaque no rodapé
  Widget _buildShowcasePill() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withAlpha(140),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(60)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.secondaryContainer,
            child: Icon(Icons.bakery_dining_outlined, size: 20, color: AppColors.primary),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pronto para cozinhar?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                Text('32 receitas aguardam você', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.menu_book, size: 20, color: AppColors.primaryContainer),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chef’s Shelf'),
        actions: const [Padding(padding: EdgeInsets.only(right: 14), child: Icon(Icons.bookmark_outline))],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopSection(),
              const SizedBox(height: 16),
              _buildSyncBanner(),
              const SizedBox(height: 16),
              _buildForm(),
              const SizedBox(height: 16),
              _buildShowcasePill(),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: const Text('Ainda não tem uma conta? Cadastre-se', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
