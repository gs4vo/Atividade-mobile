class Product {
  const Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });

  final int? id;
  final String name;
  final double price;
  final String description;
  final String image;
  final String category;

  factory Product.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final titleValue = json['title'] ?? json['name'] ?? '';
    final priceValue = json['price'];

    return Product(
      id: _toIntOrNull(idValue),
      name: titleValue.toString(),
      price: _toDoubleOrZero(priceValue),
      description: (json['description'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      category: (json['category'] ?? 'geral').toString(),
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final json = <String, dynamic>{
      'title': name,
      'price': price,
      'description': description,
      'image': image,
      'category': category,
    };

    if (includeId && id != null) {
      json['id'] = id;
    }

    return json;
  }

  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? image,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      category: category ?? this.category,
    );
  }

  static int? _toIntOrNull(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static double _toDoubleOrZero(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.replaceAll(',', '.')) ?? 0;
    }

    return 0;
  }
}
