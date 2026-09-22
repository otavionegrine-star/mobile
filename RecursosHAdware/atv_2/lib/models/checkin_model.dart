class CheckIn {
  final int? id;
  final String dataHora;
  final double latitude;
  final double longitude;
  final String observacao;
  final String caminhoFoto;

  CheckIn({
    this.id,
    required this.dataHora,
    required this.latitude,
    required this.longitude,
    required this.observacao,
    required this.caminhoFoto,
  });

  // Converte o objeto para um Map (para SALVAR no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_hora': dataHora,
      'latitude': latitude,
      'longitude': longitude,
      'observacao': observacao,
      'caminho_foto': caminhoFoto,
    };
  }

  // Converte um Map em objeto CheckIn (para LER do banco)
  factory CheckIn.fromMap(Map<String, dynamic> map) {
    return CheckIn(
      id: map['id'],
      dataHora: map['data_hora'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      observacao: map['observacao'],
      caminhoFoto: map['caminho_foto'],
    );
  }
}