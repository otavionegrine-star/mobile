class Morador {
  final int? id;
  final String nome;
  final String documento;
  final int idade;
  final String endereco;

  Morador({
    this.id,
    required this.nome,
    required this.documento,
    required this.idade,
    required this.endereco,
  });

  // Converte um Morador em um Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'documento': documento,
      'idade': idade,
      'endereco': endereco,
    };
  }

  // Cria um Morador a partir de um Map do banco
  factory Morador.fromMap(Map<String, dynamic> map) {
    return Morador(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      documento: map['documento'] as String,
      idade: map['idade'] as int,
      endereco: map['endereco'] as String,
    );
  }
}