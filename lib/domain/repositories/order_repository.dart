import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/cart_item_entity.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, OrderEntity>> placeOrder({
    required List<CartItemEntity> items,
    required Map<String, String> shippingInfo,
    required String paymentMethod,
    required double subtotal,
    required double shipping,
    required double total,
  });
}
