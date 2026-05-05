import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItemEntity> _items = [];

  @override
  List<CartItemEntity> getCartItems() => List.unmodifiable(_items);

  @override
  Either<Failure, void> addToCart(
    ProductEntity product, {
    String? size,
    String? color,
    int quantity = 1,
  }) {
    try {
      final idx = _items.indexWhere(
        (item) =>
            item.product.id == product.id &&
            item.selectedSize == size &&
            item.selectedColor == color,
      );
      if (idx >= 0) {
        _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity + quantity);
      } else {
        _items.add(CartItemEntity(
          product: product,
          quantity: quantity,
          selectedSize: size,
          selectedColor: color,
        ));
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Either<Failure, void> removeFromCart(
    String productId, {
    String? size,
    String? color,
  }) {
    try {
      _items.removeWhere(
        (item) =>
            item.product.id == productId &&
            item.selectedSize == size &&
            item.selectedColor == color,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Either<Failure, void> updateQuantity(
    String productId,
    int quantity, {
    String? size,
    String? color,
  }) {
    try {
      final idx = _items.indexWhere(
        (item) =>
            item.product.id == productId &&
            item.selectedSize == size &&
            item.selectedColor == color,
      );
      if (idx >= 0) {
        if (quantity <= 0) {
          _items.removeAt(idx);
        } else {
          _items[idx] = _items[idx].copyWith(quantity: quantity);
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  void clearCart() => _items.clear();
}
