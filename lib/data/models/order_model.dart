import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.productName,
    super.imageUrl,
    required super.price,
    required super.quantity,
    super.selectedSize,
    super.selectedColor,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        productId: json['productId'] as String? ?? '',
        productName: json['productName'] as String? ?? '',
        imageUrl: json['imageUrl'] as String?,
        price: (json['price'] as num? ?? 0).toDouble(),
        quantity: json['quantity'] as int? ?? 1,
        selectedSize: json['selectedSize'] as String?,
        selectedColor: json['selectedColor'] as String?,
      );

  static OrderItemModel fromCartItem(CartItemEntity item) => OrderItemModel(
        productId: item.product.id,
        productName: item.product.name,
        imageUrl: item.product.imageUrl,
        price: item.product.price,
        quantity: item.quantity,
        selectedSize: item.selectedSize,
        selectedColor: item.selectedColor,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
        if (selectedSize != null) 'selectedSize': selectedSize,
        if (selectedColor != null) 'selectedColor': selectedColor,
      };
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.items,
    required super.shippingInfo,
    required super.paymentMethod,
    required super.subtotal,
    required super.shipping,
    required super.total,
    required super.status,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String? ?? '',
        items: (json['items'] as List? ?? [])
            .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        shippingInfo: (json['shippingInfo'] as Map?)
                ?.map((k, v) => MapEntry(k.toString(), v.toString())) ??
            {},
        paymentMethod: json['paymentMethod'] as String? ?? '',
        subtotal: (json['subtotal'] as num? ?? 0).toDouble(),
        shipping: (json['shipping'] as num? ?? 0).toDouble(),
        total: (json['total'] as num? ?? 0).toDouble(),
        status: json['status'] as String? ?? 'confirmed',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}
