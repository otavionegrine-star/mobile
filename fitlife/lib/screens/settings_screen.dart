import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Controla o campo de edição do nome de usuário.
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    final currentUsername = context.read<SettingsProvider>().username;
    _usernameController = TextEditingController(
      text: currentUsername == 'Usuário' ? '' : currentUsername,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Observa o provider para responder a mudanças no tema e no nome do usuário.
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Configurações',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            child: SwitchListTile(
              title: const Text('Tema Escuro'),
              value: settings.isDarkMode,
              secondary: const Icon(Icons.dark_mode),
              onChanged: settings.toggleDarkMode,
            ),
          ),
          // Altera o modo escuro diretamente no provider.
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nome de usuário',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Digite seu nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      final username = _usernameController.text.trim();
                      if (username.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Informe um nome de usuário válido.'),
                          ),
                        );
                        return;
                      }
                      // Atualiza o nome do usuário nas configurações do app.
                      settings.setUsername(username);
                    },
                    child: const Text('Salvar nome de usuário'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre o App'),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Fit Life',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2026 Fit Life',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
