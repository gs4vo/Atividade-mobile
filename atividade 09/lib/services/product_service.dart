import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  ProductService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://fakestoreapi.com/products';
  final http.Client _client;

  Future<List<Product>> fetchProducts() async {
    final response = await _client.get(Uri.parse(_baseUrl));

    _ensureSuccessStatusCode(response, action: 'carregar produtos');

    final body = jsonDecode(response.body);
    if (body is! List<dynamic>) {
      throw Exception('Resposta inesperada ao carregar produtos.');
    }

    return body
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Product> addProduct(Product product) async {
    final response = await _client.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson(includeId: false)),
    );

    _ensureSuccessStatusCode(response, action: 'adicionar produto');
    return _decodeSingleProduct(response.body, fallback: product);
  }

  Future<Product> updateProduct(Product product) async {
    if (product.id == null) {
      throw Exception('ID obrigatório para atualizar produto.');
    }

    final response = await _client.put(
      Uri.parse('$_baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson(includeId: true)),
    );

    _ensureSuccessStatusCode(response, action: 'atualizar produto');
    return _decodeSingleProduct(response.body, fallback: product);
  }

  Future<bool> deleteProduct(String id) async {
    final response = await _client.delete(Uri.parse('$_baseUrl/$id'));
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Product _decodeSingleProduct(String body, {required Product fallback}) {
    final data = jsonDecode(body);
    if (data is! Map<String, dynamic>) {
      return fallback;
    }

    final decodedProduct = Product.fromJson(data);
    if (decodedProduct.id == null && fallback.id != null) {
      return decodedProduct.copyWith(id: fallback.id);
    }

    return decodedProduct;
  }

  void _ensureSuccessStatusCode(
    http.Response response, {
    required String action,
  }) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Falha ao $action (status: ${response.statusCode}).',
      );
    }
  }
}
