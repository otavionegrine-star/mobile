import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/atividade_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta as alterações no provider para atualizar as métricas
    final provider = context.watch<AtividadeProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seu Desempenho',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard(
                'Concluídas',
                '${provider.totalConcluidas}',
                Icons.check_circle_outline,
                Colors.blue,
              ),
              _buildStatCard(
                'Pendentes',
                '${provider.pendentes.length}',
                Icons.pending_actions,
                Colors.orange,
              ),
              _buildStatCard(
                'Calorias',
                '${provider.totalConcluidas * 150} kcal',
                Icons.local_fire_department,
                Colors.red,
              ),
              _buildStatCard(
                'Meta Semanal',
                '${(provider.progressoMeta * 100).toInt()}%',
                Icons.flag_circle,
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Exemplo de um Widget de progresso visual
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Progresso Diário'),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: provider.progressoMeta,
                    backgroundColor: Colors.grey[200],
                    color: Colors.green,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}