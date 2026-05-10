import 'package:get/get.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/cart_usecases.dart';
import 'package:flutter/material.dart';

class CartController extends GetxController {
  final AddToCartUseCase _addToCart;
  final RemoveFromCartUseCase _removeFromCart;
  final UpdateCartQuantityUseCase _updateQuantity;
  final GetCartItemsUseCase _getCartItems;
  final ClearCartUseCase _clearCart;

  CartController({
    required AddToCartUseCase addToCart,
    required RemoveFromCartUseCase removeFromCart,
    required UpdateCartQuantityUseCase updateQuantity,
    required GetCartItemsUseCase getCartItems,
    required ClearCartUseCase clearCart,
  })  : _addToCart = addToCart,
        _removeFromCart = removeFromCart,
        _updateQuantity = updateQuantity,
        _getCartItems = getCartItems,
        _clearCart = clearCart;

  final RxList<CartItemEntity> cartItems = <CartItemEntity>[].obs;

  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => cartItems.fold(0.0, (sum, item) => sum + item.total);
  double get shipping => subtotal > 0 ? (subtotal >= 100 ? 0 : 9.99) : 0;
  double get total => subtotal + shipping;

  @override
  void onInit() {
    super.onInit();
    _refresh();
  }

  void _refresh() => cartItems.assignAll(_getCartItems());

  void addToCart(
    ProductEntity product, {
    String? size,
    String? color,
    int quantity = 1,
  }) {
    _addToCart(product, size: size, color: color, quantity: quantity);
    _refresh();
    Get.snackbar(
      'Added to Cart',
      '${product.name} added successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  void removeFromCart(String productId, {String? size, String? color}) {
    _removeFromCart(productId, size: size, color: color);
    _refresh();
  }

  void updateQuantity(String productId, int quantity, {String? size, String? color}) {
    _updateQuantity(productId, quantity, size: size, color: color);
    _refresh();
  }

  void clearCart() {
    _clearCart();
    _refresh();
  }

  bool isInCart(String productId) =>
      cartItems.any((item) => item.product.id == productId);
}
