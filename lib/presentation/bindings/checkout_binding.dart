import 'package:get/get.dart';
import '../../domain/usecases/process_payment_usecase.dart';
import '../../domain/usecases/order_usecases.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckoutController(
          processPayment: Get.find<ProcessPaymentUseCase>(),
          placeOrder: Get.find<PlaceOrderUseCase>(),
        ));
  }
}
