import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required ProductRemoteDataSource remote, required ProductLocalDataSource local})
      : _remote = remote,
        _local = local;

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await _remote.getProducts();
      await _local.cacheProducts(products);
      return products;
    } catch (e) {
      try {
        final cached = await _local.getCachedProducts();
        if (cached != null && cached.isNotEmpty) {
          return cached;
        }
      } catch (_) {
        // ignore local cache errors; prefer original error
      }
      rethrow;
    }
  }
}
