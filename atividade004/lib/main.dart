import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/usecases/get_products.dart';
import 'presentation/products/products_page.dart';

void main() {
  final httpClient = http.Client();
  final apiClient = ApiClient(
    httpClient: httpClient,
    baseUrl: 'https://fakestoreapi.com',
  );
  final remoteDataSource = ProductRemoteDataSourceImpl(apiClient);
  final repository = ProductRepositoryImpl(remoteDataSource);
  final getProducts = GetProducts(repository);

  runApp(MyApp(getProducts: getProducts));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.getProducts});

  final GetProducts getProducts;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividade 04',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProductsPage(getProducts: getProducts),
    );
  }
}
