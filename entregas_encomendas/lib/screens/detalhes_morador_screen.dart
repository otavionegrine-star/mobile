import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/morador_model.dart';
import '../models/encomenda_model.dart';

class DetalhesMoradorScreen extends StatefulWidget {
  final Morador morador;
  const DetalhesMoradorScreen({super.key, required this.morador});

  @override
  State<DetalhesMoradorScreen> createState() => _DetalhesMoradorScreenState();
}

class _DetalhesMoradorScreenState extends State<DetalhesMoradorScreen> {
  List<Encomenda> _encomendas = [];
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _tipoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarEncomendas();
  }

  Future<void> _carregarEncomendas() async {
    setState(() => _isLoading = true);
    final dados = await DbHelper.instance.readEncomendasPorMorador(widget.morador.id!);
    setState(() {
      _encomendas = dados;
      _isLoading = false;
    });
  }

  void _exibirFormularioEncomenda() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20, left: 20, right: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Registrar Nova Encomenda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Encomenda (Ex: Caixa, Envelope, Mercado Livre)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Insira o tipo da encomenda' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                onPressed: _salvarEncomenda,
                child: const Text('Registrar Entrada'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salvarEncomenda() async {
    if (_formKey.currentState!.validate()) {
      final dataAtual = DateTime.now().toString().substring(0, 16); // Formato YYYY-MM-DD HH:MM
      
      final novaEncomenda = Encomenda(
        moradorId: widget.morador.id!,
        dataEntrega: dataAtual,
        dataSaida: 'Aguardando Retirada',
        tipoEncomenda: _tipoController.text,
        status: 'Pendente',
      );

      await DbHelper.instance.insertEncomenda(novaEncomenda);
      _tipoController.clear();
      Navigator.pop(context);
      _carregarEncomendas();
    }
  }

  Future<void> _registrarSaida(Encomenda enc) async {
    final dataAtual = DateTime.now().toString().substring(0, 16);
    final encomendaAtualizada = Encomenda(
      id: enc.id,
      moradorId: enc.moradorId,
      dataEntrega: enc.dataEntrega,
      dataSaida: dataAtual,
      tipoEncomenda: enc.tipoEncomenda,
      status: 'Retirado',
    );

    await DbHelper.instance.updateEncomenda(encomendaAtualizada);
    _carregarEncomendas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.morador.nome)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ficha Detalhada do Morador (Requisito do Briefing)
          Card(
            margin: const EdgeInsets.all(15),
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ficha do Morador', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  const Divider(),
                  Text('Nome: ${widget.morador.nome}'),
                  Text('Documento: ${widget.morador.documento}'),
                  Text('Idade: ${widget.morador.idade} anos'),
                  Text('Endereço: ${widget.morador.endereco}'),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text('Histórico de Encomendas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // Lista de Elementos Relacionados
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _encomendas.isEmpty
                    ? const Center(child: Text('Nenhuma encomenda para este morador.'))
                    : ListView.builder(
                        itemCount: _encomendas.length,
                        itemBuilder: (context, index) {
                          final enc = _encomendas[index];
                          final isPendente = enc.status == 'Pendente';
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: ListTile(
                              leading: Icon(
                                isPendente ? Icons.all_inbox : Icons.done_all,
                                color: isPendente ? Colors.orange : Colors.green,
                              ),
                              title: Text(enc.tipoEncomenda, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Entrada: ${enc.dataEntrega}\nSaída: ${enc.dataSaida}'),
                              trailing: isPendente
                                  ? ElevatedButton(
                                      onPressed: () => _registrarSaida(enc),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100),
                                      child: const Text('Dar Saída', style: TextStyle(color: Colors.black)),
                                    )
                                  : const Text('Entregue', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            ),
                          );
                        },
                      ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exibirFormularioEncomenda,
        label: const Text('Nova Encomenda'),
        icon: const Icon(Icons.add_box),
      ),
    );
  }
}