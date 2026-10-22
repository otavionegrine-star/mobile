// Tela de perfil e configurações reproduzindo o design system
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();
  bool _notifications = true;

  // Desconecta o usuário após confirmação
  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sair da conta?'),
        content: const Text('Você poderá entrar novamente a qualquer momento.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _auth.logout();
  }

  // Cartão com perfil do usuário e nível gastronômico
  Widget _buildProfileCard() {
    final email = _auth.currentUser?.email ?? 'mariana.silva@exemplo.com';
    final name = email.contains('@') ? email.split('@').first : email;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(60)),
        boxShadow: [BoxShadow(color: AppColors.onBackground.withAlpha(10), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: CircleAvatar(radius: 37, backgroundColor: AppColors.surfaceContainer, child: Icon(Icons.person, size: 44, color: AppColors.primary)),
          ),
          const SizedBox(height: 12),
          Text('Chef $name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          const SizedBox(height: 2),
          Text(email, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(16)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 14, color: AppColors.primary),
                SizedBox(width: 4),
                Text('Membro GourmetGo • Nível Chef', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bento com métricas culinárias
  Widget _buildBentoMetrics() {
    final metrics = [
      (Icons.bookmark, '14', 'Receitas Salvas', AppColors.primaryContainer),
      (Icons.soup_kitchen, '8', 'Pratos Feitos', AppColors.tertiaryFixedDim),
      (Icons.auto_stories, '3', 'Cadernos', AppColors.cookingMode),
    ];
    return Row(
      children: metrics.map((m) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outlineVariant.withAlpha(60)),
              ),
              child: Column(
                children: [
                  Icon(m.$1, size: 22, color: AppColors.primary),
                  const SizedBox(height: 4),
                  Text(m.$2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  Text(m.$3, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.secondary)),
                ],
              ),
            ),
          )).toList(),
    );
  }

  // Lista de itens do menu de configurações
  Widget _buildSettingsList() {
    return Column(
      children: [
        _buildListTile(Icons.translate, 'Tradução de Receitas', 'Português (pt-BR) ativado'),
        _buildListTile(Icons.eco_outlined, 'Preferências Alimentares', 'Vegetariano, Sem Glúten'),
        _buildListTile(Icons.cloud_sync_outlined, 'Sincronização em Nuvem', 'Firestore Sync Ativo'),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.outlineVariant.withAlpha(60))),
          child: SwitchListTile(
            value: _notifications,
            activeThumbColor: AppColors.primaryContainer,
            onChanged: (v) => setState(() => _notifications = v),
            title: const Text('Notificações & Dica do Dia', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            subtitle: const Text('Inspirações matinais de preparo', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
          ),
        ),
        _buildListTile(Icons.info_outline, 'Sobre o Chef’s Shelf', 'Versão 1.2.0 • TheMealDB API & Flutter'),
      ],
    );
  }

  // Item padrão de configuração
  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.outlineVariant.withAlpha(60))),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.secondary)),
        trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.outline),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chef’s Shelf')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        children: [
          const Text('Perfil & Configurações', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          const Text('Gerencie suas preferências culinárias e conta', style: TextStyle(fontSize: 12, color: AppColors.secondary)),
          const SizedBox(height: 14),
          _buildProfileCard(),
          const SizedBox(height: 14),
          _buildBentoMetrics(),
          const SizedBox(height: 18),
          _buildSettingsList(),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: AppColors.error, size: 18),
            label: const Text('Sair da conta', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
