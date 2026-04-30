import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/atividade_provider.dart';

class AtividadesScreen extends StatelessWidget {
  const AtividadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AtividadeProvider>();
    final atividades = provider.pendentes + provider.concluidas;

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: atividades.length,
        itemBuilder: (context, index) {
          final atividade = atividades[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(atividade.icone, color: atividade.concluida ? Colors.green : Colors.grey),
              title: Text(atividade.nome),
              trailing: Checkbox(
                value: atividade.concluida,
                onChanged: (_) => provider.alternarStatus(atividade.id),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.resetarProgresso(),
        tooltip: 'Resetar progresso',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}