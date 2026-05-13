import 'package:get/get.dart';
import '../../domain/usecases/order_usecases.dart';
import '../controllers/orders_controller.dart';

class OrdersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrdersController(getOrders: Get.find<GetOrdersUseCase>()));
  }
}
