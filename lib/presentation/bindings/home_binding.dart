import 'package:get/get.dart';
import '../../domain/usecases/product_usecases.dart';
import '../controllers/home_controller.dart';
import '../controllers/main_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MainController());

    Get.lazyPut(() => HomeController(
          getAllProducts: Get.find<GetAllProductsUseCase>(),
          getFeaturedProducts: Get.find<GetFeaturedProductsUseCase>(),
          getCategories: Get.find<GetCategoriesUseCase>(),
          searchProducts: Get.find<SearchProductsUseCase>(),
        ));
  }
}
