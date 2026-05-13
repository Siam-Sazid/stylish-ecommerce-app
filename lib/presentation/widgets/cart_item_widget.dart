import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'shimmer_box.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ShimmerBox(width: 80, height: 80),
              errorWidget: (_, url, error) {
                appLogger.e('[CartItem] Image failed', error: error);
                appLogger.d('[CartItem] URL: $url');
                return Container(
                  color: AppColors.background,
                  child: const Icon(Icons.image_outlined, color: AppColors.textHint),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (item.selectedColor != null || item.selectedSize != null)
                  Text(
                    [
                      if (item.selectedColor != null) item.selectedColor!,
                      if (item.selectedSize != null) 'Size: ${item.selectedSize}',
                    ].join(' · '),
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    // Quantity controls
                    Row(
                      children: [
                        _QtyButton(
                          icon: Icons.remove,
                          onTap: () => cart.updateQuantity(
                            item.product.id,
                            item.quantity - 1,
                            size: item.selectedSize,
                            color: item.selectedColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                        _QtyButton(
                          icon: Icons.add,
                          onTap: () => cart.updateQuantity(
                            item.product.id,
                            item.quantity + 1,
                            size: item.selectedSize,
                            color: item.selectedColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete button
          IconButton(
            onPressed: () => cart.removeFromCart(
              item.product.id,
              size: item.selectedSize,
              color: item.selectedColor,
            ),
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.accent, size: 22),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, size: 16, color: AppColors.text),
      ),
    );
  }
}
