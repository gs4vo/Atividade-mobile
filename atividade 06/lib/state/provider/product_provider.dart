import 'package:flutter/foundation.dart';

import '../../domain/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(name: "Notebook", price: 3500),
    Product(name: "Mouse", price: 120),
    Product(name: "Teclado", price: 250),
    Product(name: "Monitor", price: 900),
  ];

  List<Product> get products => List.unmodifiable(_products);

  void toggleFavorite(int index) {
    final selectedProduct = _products[index];
    selectedProduct.favorite = !selectedProduct.favorite;
    notifyListeners();
  }
}
