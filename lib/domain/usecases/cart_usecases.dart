import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/cart_item_entity.dart';
import '../entities/product_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;
  GetCartItemsUseCase(this.repository);
  List<CartItemEntity> call() => repository.getCartItems();
}

class AddToCartUseCase {
  final CartRepository repository;
  AddToCartUseCase(this.repository);
  Either<Failure, void> call(
    ProductEntity product, {
    String? size,
    String? color,
    int quantity = 1,
  }) =>
      repository.addToCart(product, size: size, color: color, quantity: quantity);
}

class RemoveFromCartUseCase {
  final CartRepository repository;
  RemoveFromCartUseCase(this.repository);
  Either<Failure, void> call(String productId, {String? size, String? color}) =>
      repository.removeFromCart(productId, size: size, color: color);
}

class UpdateCartQuantityUseCase {
  final CartRepository repository;
  UpdateCartQuantityUseCase(this.repository);
  Either<Failure, void> call(String productId, int quantity, {String? size, String? color}) =>
      repository.updateQuantity(productId, quantity, size: size, color: color);
}

class ClearCartUseCase {
  final CartRepository repository;
  ClearCartUseCase(this.repository);
  void call() => repository.clearCart();
}
