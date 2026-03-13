import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/product_local_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/usecases/get_products.dart';
import 'presentation/products/products_page.dart';
import 'presentation/products/products_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final httpClient = http.Client();
  final apiClient = ApiClient(
    httpClient: httpClient,
    baseUrl: 'https://fakestoreapi.com',
  );
  final remoteDataSource = ProductRemoteDataSourceImpl(apiClient);
  final localDataSource = ProductLocalDataSourceImpl(prefs);
  final repository = ProductRepositoryImpl(
    remote: remoteDataSource,
    local: localDataSource,
  );
  final getProducts = GetProducts(repository);
  final productsViewModel = ProductsViewModel(getProducts);

  runApp(MyApp(productsViewModel: productsViewModel));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.productsViewModel});

  final ProductsViewModel productsViewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividade 05',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProductsPage(viewModel: productsViewModel),
    );
  }
}
