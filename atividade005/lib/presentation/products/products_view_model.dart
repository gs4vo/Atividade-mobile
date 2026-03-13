import 'package:flutter/foundation.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';

sealed class ProductsState {
  const ProductsState();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  const ProductsLoaded(this.products);

  final List<Product> products;
}

class ProductsError extends ProductsState {
  const ProductsError(this.message);

  final String message;
}

class ProductsViewModel extends ChangeNotifier {
  ProductsViewModel(this._getProducts);

  final GetProducts _getProducts;

  ProductsState _state = const ProductsLoading();
  ProductsState get state => _state;

  Future<void> loadProducts() async {
    _state = const ProductsLoading();
    notifyListeners();

    try {
      final products = await _getProducts();
      _state = ProductsLoaded(products);
    } catch (e) {
      _state = ProductsError(_mapErrorToMessage(e));
    }

    notifyListeners();
  }

  String _mapErrorToMessage(Object error) {
    return switch (error) {
      ApiException(:final message) => message,
      _ => 'Não foi possível carregar os produtos.',
    };
  }
}
