import 'package:equatable/equatable.dart';
import 'product_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const CartItemEntity({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get total => product.price * quantity;

  CartItemEntity copyWith({
    ProductEntity? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  @override
  List<Object?> get props => [product.id, selectedSize, selectedColor];
}
