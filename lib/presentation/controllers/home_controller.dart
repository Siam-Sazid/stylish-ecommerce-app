import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/product_usecases.dart';

class HomeController extends GetxController {
  final GetAllProductsUseCase _getAllProducts;
  final GetFeaturedProductsUseCase _getFeaturedProducts;
  final GetCategoriesUseCase _getCategories;
  final SearchProductsUseCase _searchProducts;

  HomeController({
    required GetAllProductsUseCase getAllProducts,
    required GetFeaturedProductsUseCase getFeaturedProducts,
    required GetCategoriesUseCase getCategories,
    required SearchProductsUseCase searchProducts,
  })  : _getAllProducts = getAllProducts,
        _getFeaturedProducts = getFeaturedProducts,
        _getCategories = getCategories,
        _searchProducts = searchProducts;

  final RxList<ProductEntity> allProducts = <ProductEntity>[].obs;
  final RxList<ProductEntity> featuredProducts = <ProductEntity>[].obs;
  final RxList<ProductEntity> displayedProducts = <ProductEntity>[].obs;
  final RxList<CategoryEntity> categories = <CategoryEntity>[].obs;
  final RxString selectedCategoryId = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentBannerIndex = 0.obs;

  // Search form state
  final searchCtrl = TextEditingController();
  final searchHasText = false.obs;

  // Banner carousel state
  final pageController = PageController();
  Timer? _bannerTimer;

  static const List<Map<String, dynamic>> banners = [
    {
      'title': 'Summer Sale',
      'subtitle': 'Up to 50% off on electronics',
      'tag': '50% OFF',
      'gradientStart': 0xFF2563EB,
      'gradientEnd': 0xFF7C3AED,
    },
    {
      'title': 'New Arrivals',
      'subtitle': 'Discover the latest fashion trends',
      'tag': 'NEW',
      'gradientStart': 0xFF7C3AED,
      'gradientEnd': 0xFFEC4899,
    },
    {
      'title': 'Flash Deals',
      'subtitle': 'Limited time offers — grab them fast!',
      'tag': '30% OFF',
      'gradientStart': 0xFFEF4444,
      'gradientEnd': 0xFFF97316,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    loadData();
    _startBannerAutoScroll();
  }

  @override
  void onClose() {
    _bannerTimer?.cancel();
    pageController.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!pageController.hasClients) return;
      final next = (currentBannerIndex.value + 1) % banners.length;
      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> loadData() async {
    isLoading.value = true;
    errorMessage.value = '';

    final results = await Future.wait([
      _getAllProducts(),
      _getFeaturedProducts(),
      _getCategories(),
    ]);

    results[0].fold(
      (f) => errorMessage.value = f.message,
      (products) {
        allProducts.assignAll(products as List<ProductEntity>);
        displayedProducts.assignAll(products);
      },
    );
    results[1].fold(
      (_) {},
      (products) => featuredProducts.assignAll(products as List<ProductEntity>),
    );
    results[2].fold(
      (_) {},
      (cats) => categories.assignAll(cats as List<CategoryEntity>),
    );

    isLoading.value = false;
  }

  void filterByCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
    if (categoryId.isEmpty) {
      displayedProducts.assignAll(allProducts);
    } else {
      displayedProducts.assignAll(
        allProducts.where((p) => p.categoryId == categoryId).toList(),
      );
    }
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      displayedProducts.assignAll(allProducts);
      return;
    }
    final result = await _searchProducts(query.trim());
    result.fold(
      (_) {},
      (products) => displayedProducts.assignAll(products),
    );
  }
}
