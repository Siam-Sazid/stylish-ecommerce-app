import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../domain/entities/product_entity.dart';
import '../../controllers/cart_controller.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final ProductEntity product;
  String? selectedSize;
  String? selectedColor;
  int quantity = 1;
  bool _descExpanded = false;

  @override
  void initState() {
    super.initState();
    product = Get.arguments as ProductEntity;
    if (product.sizes.isNotEmpty) selectedSize = product.sizes.first;
    if (product.colors.isNotEmpty) selectedColor = product.colors.first;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                backgroundColor: AppColors.surface,
                leading: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_rounded, size: 18, color: AppColors.text),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.favorite_border_rounded, size: 20, color: AppColors.text),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppColors.background,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.background,
                      child: const Icon(Icons.image_outlined, size: 80, color: AppColors.textHint),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags row
                      Row(
                        children: [
                          if (product.isNew)
                            _Tag(label: 'NEW', color: AppColors.success),
                          if (product.discountPercent > 0)
                            _Tag(
                              label: '-${product.discountPercent.toInt()}% OFF',
                              color: AppColors.accent,
                            ),
                        ],
                      ),
                      if (product.isNew || product.discountPercent > 0) const SizedBox(height: 10),

                      Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 10),

                      // Rating row
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.star, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          Text(
                            '  (${product.reviewCount} reviews)',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          if (product.originalPrice != null) ...[
                            const SizedBox(width: 10),
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textHint,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Description
                      Text('Description', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: _descExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Text(
                          product.description,
                          style: const TextStyle(color: AppColors.textSecondary, height: 1.7, fontSize: 14),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondChild: Text(
                          product.description,
                          style: const TextStyle(color: AppColors.textSecondary, height: 1.7, fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _descExpanded = !_descExpanded),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                        child: Text(
                          _descExpanded ? 'Show less' : 'Read more',
                          style: const TextStyle(color: AppColors.primary, fontSize: 13),
                        ),
                      ),

                      // Colors
                      if (product.colors.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text('Color: ', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(width: 4),
                            Text(
                              selectedColor ?? '',
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.colors.map((color) {
                            final isSelected = selectedColor == color;
                            return GestureDetector(
                              onTap: () => setState(() => selectedColor = color),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : AppColors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.divider,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  color,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.text,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      // Sizes
                      if (product.sizes.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('Size: ', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(width: 4),
                                Text(
                                  selectedSize ?? '',
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                              child: const Text('Size Guide', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.sizes.map((size) {
                            final isSelected = selectedSize == size;
                            return GestureDetector(
                              onTap: () => setState(() => selectedSize = size),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : AppColors.surface,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.divider,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : AppColors.text,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      // Quantity
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Quantity', style: Theme.of(context).textTheme.titleMedium),
                          _QuantitySelector(
                            quantity: quantity,
                            onDecrement: () { if (quantity > 1) setState(() => quantity--); },
                            onIncrement: () => setState(() => quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom action bar
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      onPressed: () => cart.addToCart(
                        product,
                        size: selectedSize,
                        color: selectedColor,
                        quantity: quantity,
                      ),
                      icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          cart.addToCart(
                            product,
                            size: selectedSize,
                            color: selectedColor,
                            quantity: quantity,
                          );
                          Get.toNamed(AppRoutes.cart);
                        },
                        child: const Text('Buy Now'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantitySelector({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove, size: 18),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add, size: 18),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }
}
