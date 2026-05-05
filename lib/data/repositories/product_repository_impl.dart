import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;
  ProductRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
    try {
      return Right(await dataSource.getAllProducts());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      return Right(await dataSource.getProductById(id));
    } catch (e) {
      return Left(NotFoundFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String categoryId) async {
    try {
      return Right(await dataSource.getProductsByCategory(categoryId));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts() async {
    try {
      return Right(await dataSource.getFeaturedProducts());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    try {
      return Right(await dataSource.searchProducts(query));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      return Right(await dataSource.getCategories());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
