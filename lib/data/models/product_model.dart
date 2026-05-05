import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.originalPrice,
    required super.imageUrl,
    super.images,
    required super.categoryId,
    super.rating,
    super.reviewCount,
    super.isFeatured,
    super.isNew,
    super.sizes,
    super.colors,
    super.stockCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      imageUrl: json['imageUrl'] as String,
      images: List<String>.from(json['images'] ?? []),
      categoryId: json['categoryId'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      sizes: List<String>.from(json['sizes'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      stockCount: json['stockCount'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'originalPrice': originalPrice,
        'imageUrl': imageUrl,
        'images': images,
        'categoryId': categoryId,
        'rating': rating,
        'reviewCount': reviewCount,
        'isFeatured': isFeatured,
        'isNew': isNew,
        'sizes': sizes,
        'colors': colors,
        'stockCount': stockCount,
      };
}
