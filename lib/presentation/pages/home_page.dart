import 'package:flutter/material.dart';

import 'products_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductsPage()),
            );
          },
          icon: const Icon(Icons.storefront),
          label: const Text('Ver produtos'),
        ),
      ),
    );
  }
}
