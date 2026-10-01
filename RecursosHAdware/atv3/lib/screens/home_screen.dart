import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/ponto_provider.dart';
import 'login_screen.dart';

// Tela principal com painel de registro de ponto
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Executa o logout e redireciona para o login
  Future<void> _handleLogout(BuildContext context, AuthProvider auth) async {
    await auth.logout();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  // Executa o registro de ponto e exibe feedback
  Future<void> _handlePonto(BuildContext context, AuthProvider auth, PontoProvider ponto) async {
    await ponto.registrarPonto(auth.user?.uid, auth.user?.email);
    if (!context.mounted || ponto.statusMessage == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ponto.statusMessage!),
        backgroundColor: ponto.isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  // Constrói o card com informações do usuário e botão de ponto
  Widget _buildUserCard(BuildContext context, AuthProvider auth, PontoProvider ponto) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Usuário: ${auth.user?.email ?? "N/A"}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ponto.isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _handlePonto(context, auth, ponto),
                      icon: const Icon(Icons.location_on),
                      label: const Text('BATER PONTO AGORA'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Constrói o item individual da lista de pontos
  Widget _buildListItem(Map<String, dynamic> data) {
    final Timestamp? timestamp = data['timestamp'] as Timestamp?;
    final GeoPoint? location = data['location'] as GeoPoint?;

    final formattedDate = timestamp != null
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(timestamp.toDate())
        : 'Carregando data...';

    final coords = location != null
        ? 'Lat: ${location.latitude.toStringAsFixed(5)}, Lng: ${location.longitude.toStringAsFixed(5)}'
        : 'Coordenadas não disponíveis';

    return Card(
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(formattedDate),
        subtitle: Text(coords),
      ),
    );
  }

  // Constrói a lista em tempo real com os pontos registrados
  Widget _buildRecordsList(PontoProvider ponto) {
    return StreamBuilder<QuerySnapshot>(
      stream: ponto.recordsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Nenhum registro no momento.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('Nenhum registro encontrado.'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, index) => _buildListItem(docs[index].data() as Map<String, dynamic>),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final ponto = Provider.of<PontoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Registro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context, auth),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildUserCard(context, auth, ponto),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Meus Registros Recentes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildRecordsList(ponto)),
          ],
        ),
      ),
    );
  }
}
}