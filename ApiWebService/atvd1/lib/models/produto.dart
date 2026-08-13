class Produto {
  final String nome;
  final double valor;

  Produto({required this.nome, required this.valor});

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'valor': valor,
      };

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      nome: json['nome'] ?? '',
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
    );
  }
}