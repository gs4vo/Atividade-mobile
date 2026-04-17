import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final productId = product.id ?? product.name;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        key: ValueKey('product_tile_$productId'),
        onTap: onTap,
        leading: SizedBox(
          width: 48,
          height: 48,
          child: Image.network(
            product.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return const Icon(Icons.image_not_supported_outlined);
            },
          ),
        ),
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${_formatPrice(product.price)} • ${product.category}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SizedBox(
          width: 96,
          child: Row(
            children: [
              IconButton(
                key: ValueKey('edit_button_$productId'),
                tooltip: 'Editar produto',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                key: ValueKey('delete_button_$productId'),
                tooltip: 'Excluir produto',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatPrice(double price) {
  final hasDecimal = price % 1 != 0;
  final value =
      hasDecimal ? price.toStringAsFixed(2) : price.toStringAsFixed(0);
  return 'R\$ $value';
}
