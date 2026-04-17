import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider({ProductService? service})
      : _service = service ?? ProductService() {
    loadProducts();
  }

  final ProductService _service;
  final List<Product> _products = [];

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.fetchProducts();
      _products
        ..clear()
        ..addAll(result);
    } catch (_) {
      _errorMessage = 'Nao foi possivel carregar os produtos.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(Product product) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final createdProduct = await _service.addProduct(product);
      final productWithId = createdProduct.id == null
          ? createdProduct.copyWith(id: DateTime.now().millisecondsSinceEpoch)
          : createdProduct;

      _products.insert(0, productWithId);
      return true;
    } catch (_) {
      _errorMessage = 'Nao foi possivel adicionar o produto.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateProduct(Product product) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedProduct = await _service.updateProduct(product);
      final normalizedProduct = updatedProduct.id == null
          ? updatedProduct.copyWith(id: product.id)
          : updatedProduct;

      final index = _products.indexWhere((item) => item.id == product.id);
      if (index != -1) {
        _products[index] = normalizedProduct;
      }

      return true;
    } catch (_) {
      _errorMessage = 'Nao foi possivel atualizar o produto.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProduct(String id) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final deleted = await _service.deleteProduct(id);
      if (deleted) {
        _products.removeWhere((item) => item.id?.toString() == id);
      } else {
        _errorMessage = 'Nao foi possivel excluir o produto.';
      }
      return deleted;
    } catch (_) {
      _errorMessage = 'Nao foi possivel excluir o produto.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
