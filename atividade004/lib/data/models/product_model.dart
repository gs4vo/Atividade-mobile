import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] as String?)?.trim() ?? '',
      price: (json['price'] as num).toDouble(),
      image: (json['image'] as String?)?.trim() ?? '',
    );
  }
}
