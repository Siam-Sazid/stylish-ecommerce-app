import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/order_usecases.dart';
import '../../core/utils/app_logger.dart';
import '../controllers/auth_controller.dart';

class OrdersController extends GetxController {
  final GetOrdersUseCase _getOrders;

  OrdersController({required GetOrdersUseCase getOrders}) : _getOrders = getOrders;

  final RxList<OrderEntity> orders = <OrderEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final auth = Get.find<AuthController>();
    if (!auth.isLoggedIn) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _getOrders();
      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          appLogger.w('[ORDERS] Load failed: ${failure.message}');
        },
        (list) {
          orders.assignAll(list.reversed.toList());
          appLogger.i('[ORDERS] Loaded ${list.length} orders');
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
