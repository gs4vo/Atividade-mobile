import 'package:flutter/material.dart';

import 'product_list_tile.dart';
import 'products_view_model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.viewModel});

  final ProductsViewModel viewModel;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadProducts();
  }

  void _retry() {
    widget.viewModel.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: AnimatedBuilder(
        animation: widget.viewModel,
        builder: (context, _) {
          final state = widget.viewModel.state;

          return switch (state) {
            ProductsLoading() => const Center(child: CircularProgressIndicator()),
            ProductsError(:final message) => Center(
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
              ),
            ProductsLoaded(:final products) => ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: products.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return ProductListTile(product: products[index]);
                },
              ),
          };
        },
      ),
    );
  }
}
