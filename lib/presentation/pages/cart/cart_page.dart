import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../controllers/cart_controller.dart';
import '../../widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.surface,
        title: const Text('My Cart'),
        actions: [
          Obx(() => cart.cartItems.isNotEmpty
              ? TextButton(
                  onPressed: () => _confirmClear(cart),
                  child: const Text('Clear All', style: TextStyle(color: AppColors.accent, fontSize: 13)),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (cart.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_cart_outlined, size: 48, color: AppColors.primary),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add some products to get started',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: const Text('Continue Shopping'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cart.cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => CartItemWidget(item: cart.cartItems[index]),
              ),
            ),
            // Order summary
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _SummaryRow(label: 'Subtotal', value: '\$${cart.subtotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'Shipping',
                    value: cart.shipping == 0 ? 'FREE' : '\$${cart.shipping.toStringAsFixed(2)}',
                    valueColor: cart.shipping == 0 ? AppColors.success : null,
                  ),
                  if (cart.shipping > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Free shipping on orders over \$100',
                      style: const TextStyle(color: AppColors.textHint, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'Total',
                    value: '\$${cart.total.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.checkout),
                      icon: const Icon(Icons.payment_rounded, size: 20),
                      label: const Text('Proceed to Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _confirmClear(CartController cart) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              cart.clearCart();
              Get.back();
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? AppColors.text : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? (isTotal ? AppColors.primary : AppColors.text),
          ),
        ),
      ],
    );
  }
}
