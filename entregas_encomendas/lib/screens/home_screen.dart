import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/morador_model.dart';
import 'detalhes_morador_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Morador> _moradores = [];
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _docController = TextEditingController();
  final _idadeController = TextEditingController();
  final _endController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshMoradores();
  }

  Future<void> _refreshMoradores() async {
    setState(() => _isLoading = true);
    try {
      final dados = await DbHelper.instance.readAllMoradores();
      setState(() {
        _moradores = dados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar moradores: $e')),
      );
    }
  }

  void _exibirFormularioCadastro() {
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Cadastrar Novo Morador', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome Completo', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Insira o nome' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _docController,
                  decoration: const InputDecoration(labelText: 'Documento (ex: CPF)', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Insira o documento' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _idadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Idade', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Insira a idade' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _endController,
                  decoration: const InputDecoration(labelText: 'Endereço/Apartamento', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Insira o endereço' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  onPressed: _salvarMorador,
                  child: const Text('Salvar Morador'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _salvarMorador() async {
    if (_formKey.currentState!.validate()) {
      final novoMorador = Morador(
        nome: _nomeController.text,
        documento: _docController.text,
        idade: int.parse(_idadeController.text),
        endereco: _endController.text,
      );

      await DbHelper.instance.insertMorador(novoMorador);
      
      _nomeController.clear();
      _docController.clear();
      _idadeController.clear();
      _endController.clear();

      Navigator.pop(context);
      _refreshMoradores();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Morador cadastrado com sucesso!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrega de Encomendas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _moradores.isEmpty
              ? const Center(child: Text('Nenhum morador cadastrado ainda.'))
              : ListView.builder(
                  itemCount: _moradores.length,
                  itemBuilder: (context, index) {
                    final morador = _moradores[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(morador.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Endereço: ${morador.endereco}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalhesMoradorScreen(morador: morador),
                            ),
                          ).then((_) => _refreshMoradores());
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exibirFormularioCadastro,
        child: const Icon(Icons.add),
      ),
    );
  }
}