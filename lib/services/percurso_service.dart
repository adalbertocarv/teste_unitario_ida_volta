import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/percurso_model.dart';

class PercursoService {
  static const String _baseUrl = 'https://www.sistemas.dftrans.df.gov.br/percurso/linha';

  Future<Percurso> buscarPercurso(String sequencial) async {
    final url = '$_baseUrl/$sequencial';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Percurso.fromJson(jsonResponse);
    } else {
      throw Exception('Falha ao carregar o percurso da linha.');
    }
  }
}
