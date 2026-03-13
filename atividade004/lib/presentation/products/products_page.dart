import 'package:flutter/material.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import 'product_list_tile.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.getProducts});

  final GetProducts getProducts;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.getProducts();
  }

  void _retry() {
    setState(() {
      _future = widget.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final error = snapshot.error;
            final message = switch (error) {
              ApiException(:final message) => message,
              _ => 'Não foi possível carregar os produtos.',
            };

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _retry,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? const <Product>[];

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: products.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ProductListTile(product: products[index]);
            },
          );
        },
      ),
    );
  }
}
