import 'package:flutter_test/flutter_test.dart';
import 'package:atv_2/models/checkin_model.dart';

void main() {
  group('Testes do Modelo CheckIn', () {
    test('Conversão de CheckIn para Map e de volta para CheckIn', () {
      final checkinOriginal = CheckIn(
        id: 1,
        dataHora: '2026-09-24 08:30:00',
        latitude: -23.550520,
        longitude: -46.633308,
        observacao: 'Visita técnica concluída no laboratório',
        caminhoFoto: '/caminho/foto_teste.jpg',
      );

      final map = checkinOriginal.toMap();

      expect(map['id'], 1);
      expect(map['data_hora'], '2026-09-24 08:30:00');
      expect(map['latitude'], -23.550520);
      expect(map['longitude'], -46.633308);
      expect(map['observacao'], 'Visita técnica concluída no laboratório');
      expect(map['caminho_foto'], '/caminho/foto_teste.jpg');

      final checkinRecriado = CheckIn.fromMap(map);

      expect(checkinRecriado.id, checkinOriginal.id);
      expect(checkinRecriado.dataHora, checkinOriginal.dataHora);
      expect(checkinRecriado.latitude, checkinOriginal.latitude);
      expect(checkinRecriado.longitude, checkinOriginal.longitude);
      expect(checkinRecriado.observacao, checkinOriginal.observacao);
      expect(checkinRecriado.caminhoFoto, checkinOriginal.caminhoFoto);
    });
  });
}
