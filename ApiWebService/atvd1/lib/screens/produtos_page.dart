import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_storage.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _storage = ProdutoStorage();

  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final produtos = await _storage.carregarProdutos();
    setState(() {
      _produtos = produtos;
    });
  }

  Future<void> _salvarProduto() async {
    if (!_formKey.currentState!.validate()) return;

    final nome = _nomeController.text;
    final valor = double.parse(_valorController.text.replaceAll(',', '.'));

    final novoProduto = Produto(nome: nome, valor: valor);

    setState(() {
      _produtos.add(novoProduto);
    });

    await _storage.salvarProdutos(_produtos);

    _nomeController.clear();
    _valorController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto salvo!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produtos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Produto',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _valorController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Valor (R\$)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe o valor';
                      if (double.tryParse(v.replaceAll(',', '.')) == null) {
                        return 'Digite um valor válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _salvarProduto,
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Expanded(
              child: _produtos.isEmpty
                  ? const Center(child: Text('Nenhum produto cadastrado.'))
                  : ListView.builder(
                      itemCount: _produtos.length,
                      itemBuilder: (context, index) {
                        final p = _produtos[index];
                        return ListTile(
                          leading: const Icon(Icons.shopping_bag),
                          title: Text(p.nome),
                          trailing: Text(
                            'R\$ ${p.valor.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}