import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_endpoints.dart';
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

class ApiProductDataSource implements ProductDataSource {
  final String baseUrl;
  final http.Client _client;

  ApiProductDataSource({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  Future<dynamic> _get(String path) async {
    final res = await _client.get(Uri.parse('$baseUrl$path'));
    if (res.statusCode != 200) throw Exception('Request failed: ${res.statusCode}');
    return jsonDecode(res.body);
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final data = await _get(AppEndpoints.products) as List;
    return data.map((j) => ProductModel.fromJson(j)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final data = await _get(AppEndpoints.productById(id));
    return ProductModel.fromJson(data);
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final data = await _get(AppEndpoints.productsByCategory(categoryId)) as List;
    return data.map((j) => ProductModel.fromJson(j)).toList();
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    final data = await _get(AppEndpoints.featuredProducts) as List;
    return data.map((j) => ProductModel.fromJson(j)).toList();
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final encoded = Uri.encodeComponent(query);
    final data = await _get('${AppEndpoints.searchProducts}?q=$encoded') as List;
    return data.map((j) => ProductModel.fromJson(j)).toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final data = await _get(AppEndpoints.categories) as List;
    return data.map((j) => CategoryModel.fromJson(j)).toList();
  }
}
