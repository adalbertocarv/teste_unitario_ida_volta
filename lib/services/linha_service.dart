import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/linha_info_model.dart';

class LinhaService {
  final String baseUrl = 'https://www.sistemas.dftrans.df.gov.br/linha';

  Future<List<LinhaOnibus>> procurarLinhaPorNumero(String numero) async {
    final response = await http.get(Uri.parse('$baseUrl/numero/$numero'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<LinhaOnibus> linhas = [];

      if (jsonData is List<dynamic> && jsonData.isNotEmpty) {
        for (var linhaData in jsonData) {
          linhas.add(LinhaOnibus.fromJson(linhaData));
        }
        return linhas;
      } else {
        throw Exception('Nenhum dado encontrado');
      }
    } else {
      throw Exception('Falha ao carregar informações da linha');
    }
  }
}
