import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/models/product.dart';

class FakeStoreApiService {
  static const _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar produtos da API.');
    }

    final body = jsonDecode(response.body) as List<dynamic>;

    return body
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
