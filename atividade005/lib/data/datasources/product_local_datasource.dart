import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

abstract interface class ProductLocalDataSource {
  Future<List<ProductModel>?> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl(this._prefs);

  static const _cacheKey = 'cached_products';

  final SharedPreferences _prefs;

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonList = products.map((p) => p.toJson()).toList(growable: false);
    final encoded = jsonEncode(jsonList);
    await _prefs.setString(_cacheKey, encoded);
  }

  @override
  Future<List<ProductModel>?> getCachedProducts() async {
    final raw = _prefs.getString(_cacheKey);
    if (raw == null || raw.trim().isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is! List) return null;

    return decoded
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map(ProductModel.fromJson)
        .toList(growable: false);
  }
}
