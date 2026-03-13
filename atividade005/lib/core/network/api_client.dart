import 'dart:convert';

import 'package:http/http.dart' as http;

import '../errors/exceptions.dart';

class ApiClient {
  ApiClient({required http.Client httpClient, required this.baseUrl})
      : _httpClient = httpClient;

  final http.Client _httpClient;
  final String baseUrl;

  Future<List<dynamic>> getJsonList(String path) async {
    final uri = Uri.parse(baseUrl).resolve(path);

    http.Response response;
    try {
      response = await _httpClient.get(uri);
    } catch (e) {
      throw ApiException('Erro de rede ao acessar $uri: $e');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Resposta inválida da API: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw ApiException('JSON inesperado: lista era esperada');
    }

    return decoded;
  }
}
