import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final String? imageUrl;
  final double price;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.price,
    required this.quantity,
    this.selectedSize,
    this.selectedColor,
  });

  double get total => price * quantity;

  @override
  List<Object?> get props => [productId, selectedSize, selectedColor];
}

class OrderEntity extends Equatable {
  final String id;
  final List<OrderItemEntity> items;
  final Map<String, String> shippingInfo;
  final String paymentMethod;
  final double subtotal;
  final double shipping;
  final double total;
  final String status;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.shippingInfo,
    required this.paymentMethod,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
