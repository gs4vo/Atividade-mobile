import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/models/product.dart';

class DummyJsonApiService {
  static const _baseUrl = 'https://dummyjson.com/products';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar produtos da API.');
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic> || body['products'] is! List<dynamic>) {
      throw Exception('Resposta inesperada ao carregar produtos.');
    }

    final products = body['products'] as List<dynamic>;
    return products
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
