import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/product_entity.dart';
import '../entities/category_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();
  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String categoryId);
  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts();
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
