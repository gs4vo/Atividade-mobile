import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  Future<void> _openForm(BuildContext context, {Product? product}) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(product: product),
      ),
    );

    if (updated == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            product == null
                ? 'Produto cadastrado com sucesso.'
                : 'Produto atualizado.',
          ),
        ),
      );
    }
  }

  Future<void> _openDetails(BuildContext context, Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Product product) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text('Deseja excluir "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted || product.id == null) {
      return;
    }

    final provider = context.read<ProductProvider>();
    final deleted = await provider.deleteProduct(product.id.toString());

    if (!context.mounted) {
      return;
    }

    final message = deleted
        ? 'Produto excluido.'
        : (provider.errorMessage ?? 'Nao foi possivel excluir o produto.');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            tooltip: 'Recarregar',
            onPressed: provider.loadProducts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: provider.loadProducts,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (provider.products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          return RefreshIndicator(
            onRefresh: provider.loadProducts,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return ProductCard(
                  product: product,
                  onTap: () => _openDetails(context, product),
                  onEdit: () => _openForm(context, product: product),
                  onDelete: () => _confirmDelete(context, product),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Novo produto',
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }
}
