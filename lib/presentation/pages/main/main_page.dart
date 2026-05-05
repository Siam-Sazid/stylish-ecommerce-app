import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/main_controller.dart';
import '../home/home_page.dart';
import '../cart/cart_page.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              HomePage(),
              SearchPage(),
              CartPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.currentIndex.value,
            onDestinationSelected: controller.changePage,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search_rounded),
                label: 'Search',
              ),
              NavigationDestination(
                icon: _CartIcon(selected: false),
                selectedIcon: _CartIcon(selected: true),
                label: 'Cart',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}

class _CartIcon extends StatelessWidget {
  final bool selected;
  const _CartIcon({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = Get.find<CartController>().itemCount;
      return Badge(
        isLabelVisible: count > 0,
        label: Text('$count', style: const TextStyle(fontSize: 10)),
        backgroundColor: AppColors.accent,
        child: Icon(
          selected ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
        ),
      );
    });
  }
}
