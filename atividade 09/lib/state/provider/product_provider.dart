import 'package:flutter/foundation.dart';

import '../../data/services/fake_store_api_service.dart';
import '../../domain/models/product.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider({FakeStoreApiService? service, List<Product>? initialProducts})
    : _service = service ?? FakeStoreApiService() {
    if (initialProducts != null && initialProducts.isNotEmpty) {
      _products.addAll(initialProducts);
    } else {
      loadProducts();
    }
  }

  final FakeStoreApiService _service;
  final List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loadedProducts = await _service.fetchProducts();
      _products
        ..clear()
        ..addAll(loadedProducts);
    } catch (_) {
      _errorMessage = 'Nao foi possivel carregar os produtos.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(int index) {
    final selectedProduct = _products[index];
    selectedProduct.favorite = !selectedProduct.favorite;
    notifyListeners();
  }
}
