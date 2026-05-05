import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> images;
  final String categoryId;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isNew;
  final List<String> sizes;
  final List<String> colors;
  final int stockCount;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.images = const [],
    required this.categoryId,
    this.rating = 4.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.isNew = false,
    this.sizes = const [],
    this.colors = const [],
    this.stockCount = 10,
  });

  double get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  @override
  List<Object?> get props => [id];
}
