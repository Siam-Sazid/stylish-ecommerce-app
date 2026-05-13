import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/cart_item_entity.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;
  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() => repository.getOrders();
}

class PlaceOrderUseCase {
  final OrderRepository repository;
  PlaceOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({
    required List<CartItemEntity> items,
    required Map<String, String> shippingInfo,
    required String paymentMethod,
    required double subtotal,
    required double shipping,
    required double total,
  }) =>
      repository.placeOrder(
        items: items,
        shippingInfo: shippingInfo,
        paymentMethod: paymentMethod,
        subtotal: subtotal,
        shipping: shipping,
        total: total,
      );
}
