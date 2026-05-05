import '../models/product_model.dart';
import '../models/category_model.dart';

abstract class ProductDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<List<ProductModel>> getFeaturedProducts();
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<CategoryModel>> getCategories();
}

class MockProductDataSource implements ProductDataSource {
  static final List<CategoryModel> _categories = [
    const CategoryModel(id: '1', name: 'Electronics', iconName: 'electronics'),
    const CategoryModel(id: '2', name: 'Fashion', iconName: 'fashion'),
    const CategoryModel(id: '3', name: 'Sports', iconName: 'sports'),
    const CategoryModel(id: '4', name: 'Home', iconName: 'home'),
    const CategoryModel(id: '5', name: 'Beauty', iconName: 'beauty'),
    const CategoryModel(id: '6', name: 'Books', iconName: 'books'),
  ];

  static final List<ProductModel> _products = [
    const ProductModel(
      id: '1',
      name: 'iPhone 15 Pro',
      description:
          'The latest iPhone featuring the powerful A17 Pro chip, titanium design, and a pro camera system with 48MP main. Experience the stunning Super Retina XDR display.',
      price: 999.99,
      originalPrice: 1099.99,
      imageUrl: 'https://picsum.photos/seed/iphone15/400/500',
      images: [
        'https://picsum.photos/seed/iphone15a/400/500',
        'https://picsum.photos/seed/iphone15b/400/500',
      ],
      categoryId: '1',
      rating: 4.8,
      reviewCount: 2547,
      isFeatured: true,
      isNew: true,
      colors: ['Black Titanium', 'White Titanium', 'Blue Titanium', 'Natural'],
    ),
    const ProductModel(
      id: '2',
      name: 'MacBook Air M3',
      description:
          'Supercharged by M3 chip with up to 18 hours of battery life. Stunning Liquid Retina display and MagSafe charging.',
      price: 1299.99,
      originalPrice: 1499.99,
      imageUrl: 'https://picsum.photos/seed/macbookm3/400/500',
      images: [
        'https://picsum.photos/seed/macbookm3a/400/500',
        'https://picsum.photos/seed/macbookm3b/400/500',
      ],
      categoryId: '1',
      rating: 4.9,
      reviewCount: 1823,
      isFeatured: true,
      colors: ['Silver', 'Midnight', 'Starlight', 'Sky Blue'],
    ),
    const ProductModel(
      id: '3',
      name: 'Sony WH-1000XM5',
      description:
          'Industry-leading noise canceling headphones with exceptional sound quality, 30-hour battery life, and multipoint connection.',
      price: 279.99,
      originalPrice: 349.99,
      imageUrl: 'https://picsum.photos/seed/sonyxm5/400/500',
      categoryId: '1',
      rating: 4.7,
      reviewCount: 4123,
      isFeatured: true,
      colors: ['Black', 'Silver'],
    ),
    const ProductModel(
      id: '4',
      name: 'Samsung Galaxy Tab S9',
      description:
          'Premium Android tablet with Dynamic AMOLED 2X display, S Pen included, and IP68 water resistance.',
      price: 799.99,
      imageUrl: 'https://picsum.photos/seed/tabs9/400/500',
      categoryId: '1',
      rating: 4.6,
      reviewCount: 892,
      isNew: true,
      colors: ['Graphite', 'Beige', 'Lavender'],
    ),
    const ProductModel(
      id: '5',
      name: 'Wireless Charging Pad',
      description:
          '15W fast wireless charger compatible with all Qi-enabled devices. Sleek and compact design with LED indicator.',
      price: 29.99,
      originalPrice: 39.99,
      imageUrl: 'https://picsum.photos/seed/wirelesspad/400/500',
      categoryId: '1',
      rating: 4.5,
      reviewCount: 1234,
      isNew: true,
      colors: ['White', 'Black'],
    ),
    const ProductModel(
      id: '6',
      name: 'Classic Leather Jacket',
      description:
          'Genuine leather jacket with premium stitching and a timeless design. Perfect for casual and semi-formal occasions.',
      price: 189.99,
      originalPrice: 249.99,
      imageUrl: 'https://picsum.photos/seed/leatherjacket/400/500',
      categoryId: '2',
      rating: 4.5,
      reviewCount: 567,
      isFeatured: true,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['Black', 'Brown', 'Tan'],
    ),
    const ProductModel(
      id: '7',
      name: 'Summer Floral Dress',
      description:
          'Light and breezy floral dress perfect for summer occasions. Made from 100% breathable cotton.',
      price: 59.99,
      originalPrice: 79.99,
      imageUrl: 'https://picsum.photos/seed/floraldress/400/500',
      categoryId: '2',
      rating: 4.3,
      reviewCount: 234,
      isNew: true,
      sizes: ['XS', 'S', 'M', 'L'],
      colors: ['Blue Floral', 'Pink Floral', 'White Floral'],
    ),
    const ProductModel(
      id: '8',
      name: 'Minimalist Backpack',
      description:
          'Water-resistant 30L backpack with dedicated laptop compartment and ergonomic shoulder straps for daily commuting.',
      price: 69.99,
      imageUrl: 'https://picsum.photos/seed/backpack30l/400/500',
      categoryId: '2',
      rating: 4.4,
      reviewCount: 543,
      colors: ['Black', 'Grey', 'Navy'],
    ),
    const ProductModel(
      id: '9',
      name: 'Nike Air Max 270',
      description:
          'Iconic cushioning meets stylish design. The Air Max 270 provides all-day comfort with its large Air unit heel.',
      price: 129.99,
      originalPrice: 159.99,
      imageUrl: 'https://picsum.photos/seed/nikeairmax/400/500',
      categoryId: '3',
      rating: 4.7,
      reviewCount: 3421,
      isFeatured: true,
      sizes: ['6', '7', '8', '9', '10', '11', '12'],
      colors: ['Black/White', 'White/Red', 'Blue/White'],
    ),
    const ProductModel(
      id: '10',
      name: 'Premium Yoga Mat',
      description:
          'Non-slip yoga mat with 6mm cushioning for joint protection. Eco-friendly TPE material with alignment lines.',
      price: 45.99,
      imageUrl: 'https://picsum.photos/seed/yogamatprem/400/500',
      categoryId: '3',
      rating: 4.4,
      reviewCount: 789,
      colors: ['Purple', 'Blue', 'Green', 'Pink'],
    ),
    const ProductModel(
      id: '11',
      name: 'Modern Floor Lamp',
      description:
          'Elegant LED floor lamp with adjustable brightness and color temperature. Minimalist design suits any interior.',
      price: 89.99,
      originalPrice: 119.99,
      imageUrl: 'https://picsum.photos/seed/floorlamp/400/500',
      categoryId: '4',
      rating: 4.2,
      reviewCount: 345,
      colors: ['White', 'Black', 'Gold'],
    ),
    const ProductModel(
      id: '12',
      name: 'Luxury Skincare Set',
      description:
          'Complete skincare routine in one luxurious set. Includes cleanser, toner, vitamin C serum, and moisturizer.',
      price: 79.99,
      originalPrice: 110.00,
      imageUrl: 'https://picsum.photos/seed/skincaret/400/500',
      categoryId: '5',
      rating: 4.6,
      reviewCount: 876,
      isFeatured: true,
    ),
  ];

  @override
  Future<List<ProductModel>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _products;
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products.where((p) => p.isFeatured).toList();
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lower = query.toLowerCase();
    return _products
        .where((p) =>
            p.name.toLowerCase().contains(lower) ||
            p.description.toLowerCase().contains(lower))
        .toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _categories;
  }
}
