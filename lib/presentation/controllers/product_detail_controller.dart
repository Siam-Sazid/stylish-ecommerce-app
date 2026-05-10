import 'package:get/get.dart';
import '../../../domain/entities/product_entity.dart';

class ProductDetailController extends GetxController {
  late final ProductEntity product;
  final selectedSize = ''.obs;
  final selectedColor = ''.obs;
  final quantity = 1.obs;
  final descExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as ProductEntity;
    if (product.sizes.isNotEmpty) selectedSize.value = product.sizes.first;
    if (product.colors.isNotEmpty) selectedColor.value = product.colors.first;
  }

  void toggleDescription() => descExpanded.toggle();
  void selectSize(String size) => selectedSize.value = size;
  void selectColor(String color) => selectedColor.value = color;
  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }
}
