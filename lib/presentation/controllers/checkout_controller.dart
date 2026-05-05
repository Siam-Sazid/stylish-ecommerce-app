import 'package:get/get.dart';
import '../../domain/usecases/process_payment_usecase.dart';
import 'cart_controller.dart';

class CheckoutController extends GetxController {
  final ProcessPaymentUseCase _processPayment;

  CheckoutController({required ProcessPaymentUseCase processPayment})
      : _processPayment = processPayment;

  final RxBool isProcessing = false.obs;
  final RxBool paymentSuccess = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString fullName = ''.obs;
  final RxString address = ''.obs;
  final RxString city = ''.obs;
  final RxString zipCode = ''.obs;

  Future<void> processPayment({
    required double amount,
    required String email,
  }) async {
    isProcessing.value = true;
    errorMessage.value = '';

    final result = await _processPayment(
      amount: amount,
      currency: 'usd',
      email: email,
    );

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        Get.snackbar(
          'Payment Failed',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        paymentSuccess.value = true;
        Get.find<CartController>().clearCart();
      },
    );

    isProcessing.value = false;
  }
}
