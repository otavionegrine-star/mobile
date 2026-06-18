class Encomenda {
  final int? id;
  final int moradorId; // Chave estrangeira ligando ao Morador
  final String dataEntrega;
  final String dataSaida; // Data/Hora que o morador retirou
  final String tipoEncomenda; // Ex: Caixa, Carta, Alimento
  final String status; // Ex: Pendente, Retirado

  Encomenda({
    this.id,
    required this.moradorId,
    required this.dataEntrega,
    required this.dataSaida,
    required this.tipoEncomenda,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'morador_id': moradorId,
      'data_entrega': dataEntrega,
      'data_saida': dataSaida,
      'tipo_encomenda': tipoEncomenda,
      'status': status,
    };
  }

  factory Encomenda.fromMap(Map<String, dynamic> map) {
    return Encomenda(
      id: map['id'] as int?,
      moradorId: map['morador_id'] as int,
      dataEntrega: map['data_entrega'] as String,
      dataSaida: map['data_saida'] as String,
      tipoEncomenda: map['tipo_encomenda'] as String,
      status: map['status'] as String,
    );
  }
}