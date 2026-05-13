import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource dataSource;
  OrderRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      return Right(await dataSource.getOrders());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> placeOrder({
    required List<CartItemEntity> items,
    required Map<String, String> shippingInfo,
    required String paymentMethod,
    required double subtotal,
    required double shipping,
    required double total,
  }) async {
    try {
      return Right(await dataSource.placeOrder(
        items: items,
        shippingInfo: shippingInfo,
        paymentMethod: paymentMethod,
        subtotal: subtotal,
        shipping: shipping,
        total: total,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
