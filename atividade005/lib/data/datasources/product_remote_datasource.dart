import '../../core/network/api_client.dart';
import '../models/product_model.dart';

abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<ProductModel>> getProducts() async {
    final list = await _client.getJsonList('/products');
    return list
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList(growable: false);
  }
}
