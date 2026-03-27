import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/provider/product_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Produtos")),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: productProvider.products.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final product = productProvider.products[index];

          return ListTile(
            title: Text(product.name),
            subtitle: Text(_formatPrice(product.price)),
            trailing: IconButton(
              tooltip: product.favorite
                  ? "Remover dos favoritos"
                  : "Marcar como favorito",
              icon: Icon(
                product.favorite ? Icons.star : Icons.star_border,
                color: product.favorite ? Colors.amber : null,
              ),
              onPressed: () {
                context.read<ProductProvider>().toggleFavorite(index);
              },
            ),
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

  return "R\$ $formattedPrice";
}
