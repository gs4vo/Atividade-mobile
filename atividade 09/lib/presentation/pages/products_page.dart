import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/provider/product_provider.dart';
import 'product_details_page.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: Builder(
        builder: (_) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(productProvider.errorMessage!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<ProductProvider>().loadProducts(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (productProvider.products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: productProvider.products.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final product = productProvider.products[index];

              return ListTile(
                leading: ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey.shade100,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Icon(Icons.image_not_supported);
                      },
                    ),
                  ),
                ),
                title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(_formatPrice(product.price)),
                trailing: IconButton(
                  tooltip: product.favorite
                      ? 'Remover dos favoritos'
                      : 'Marcar como favorito',
                  icon: Icon(
                    product.favorite ? Icons.star : Icons.star_border,
                    color: product.favorite ? Colors.amber : null,
                  ),
                  onPressed: () {
                    context.read<ProductProvider>().toggleFavorite(index);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(product: product),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

String _formatPrice(double price) {
  final hasDecimalPart = price % 1 != 0;
  final formattedPrice = hasDecimalPart
      ? price.toStringAsFixed(2)
      : price.toStringAsFixed(0);

  return 'R\$ $formattedPrice';
}
