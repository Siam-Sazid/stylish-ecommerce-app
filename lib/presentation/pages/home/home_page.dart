import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/main_controller.dart';
import '../../widgets/banner_carousel_widget.dart';
import '../../widgets/category_chip_widget.dart';
import '../../widgets/product_card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: controller.loadData,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: AppColors.surface,
              automaticallyImplyLeading: false,
              title: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        auth.isLoggedIn
                            ? 'Hello, ${auth.currentUser.value?.name.split(' ').first}!'
                            : 'Hello, Guest!',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text(
                        'Find your product',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.text),
                      ),
                    ],
                  )),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                const SizedBox(width: 4),
              ],
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: GestureDetector(
                  onTap: () => Get.find<MainController>().changePage(1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Search products, brands...',
                          style: TextStyle(color: AppColors.textHint, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Banner carousel
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: BannerCarouselWidget(),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Text('Categories', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Obx(() => SizedBox(
                        height: 44,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: controller.categories.length + 1,
                          itemBuilder: (_, index) {
                            if (index == 0) {
                              return CategoryChipWidget(
                                label: 'All',
                                iconName: 'all',
                                isSelected: controller.selectedCategoryId.value.isEmpty,
                                onTap: () => controller.filterByCategory(''),
                              );
                            }
                            final cat = controller.categories[index - 1];
                            return CategoryChipWidget(
                              label: cat.name,
                              iconName: cat.iconName,
                              isSelected: controller.selectedCategoryId.value == cat.id,
                              onTap: () => controller.filterByCategory(cat.id),
                            );
                          },
                        ),
                      )),
                ],
              ),
            ),

            // Featured products (horizontal)
            Obx(() {
              if (controller.featuredProducts.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Featured', style: Theme.of(context).textTheme.titleLarge),
                          TextButton(
                            onPressed: () {},
                            child: const Text('See All', style: TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.featuredProducts.length,
                        itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SizedBox(
                            width: 158,
                            child: ProductCardWidget(product: controller.featuredProducts[index]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Section header for all products
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Obx(() => Text(
                      controller.selectedCategoryId.value.isEmpty
                          ? 'All Products'
                          : controller.categories
                              .firstWhere(
                                (c) => c.id == controller.selectedCategoryId.value,
                                orElse: () => controller.categories.first,
                              )
                              .name,
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
              ),
            ),

            // Products grid
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              if (controller.displayedProducts.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded, size: 56, color: AppColors.textHint),
                          SizedBox(height: 12),
                          Text('No products found', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => ProductCardWidget(product: controller.displayedProducts[index]),
                    childCount: controller.displayedProducts.length,
                  ),
                ),
              );
            }),

            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }
}
