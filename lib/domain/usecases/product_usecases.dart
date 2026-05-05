import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/product_entity.dart';
import '../entities/category_entity.dart';
import '../repositories/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;
  GetAllProductsUseCase(this.repository);
  Future<Either<Failure, List<ProductEntity>>> call() => repository.getAllProducts();
}

class GetFeaturedProductsUseCase {
  final ProductRepository repository;
  GetFeaturedProductsUseCase(this.repository);
  Future<Either<Failure, List<ProductEntity>>> call() => repository.getFeaturedProducts();
}

class GetCategoriesUseCase {
  final ProductRepository repository;
  GetCategoriesUseCase(this.repository);
  Future<Either<Failure, List<CategoryEntity>>> call() => repository.getCategories();
}

class GetProductsByCategoryUseCase {
  final ProductRepository repository;
  GetProductsByCategoryUseCase(this.repository);
  Future<Either<Failure, List<ProductEntity>>> call(String categoryId) =>
      repository.getProductsByCategory(categoryId);
}

class SearchProductsUseCase {
  final ProductRepository repository;
  SearchProductsUseCase(this.repository);
  Future<Either<Failure, List<ProductEntity>>> call(String query) =>
      repository.searchProducts(query);
}

class GetProductByIdUseCase {
  final ProductRepository repository;
  GetProductByIdUseCase(this.repository);
  Future<Either<Failure, ProductEntity>> call(String id) => repository.getProductById(id);
}
