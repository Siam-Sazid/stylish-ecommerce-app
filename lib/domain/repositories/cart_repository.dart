import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/cart_item_entity.dart';
import '../entities/product_entity.dart';

abstract class CartRepository {
  List<CartItemEntity> getCartItems();
  Either<Failure, void> addToCart(
    ProductEntity product, {
    String? size,
    String? color,
    int quantity = 1,
  });
  Either<Failure, void> removeFromCart(
    String productId, {
    String? size,
    String? color,
  });
  Either<Failure, void> updateQuantity(
    String productId,
    int quantity, {
    String? size,
    String? color,
  });
  void clearCart();
}
