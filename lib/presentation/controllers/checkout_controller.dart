import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/process_payment_usecase.dart';
import '../../domain/usecases/order_usecases.dart';
import '../../core/utils/app_logger.dart';
import '../controllers/auth_controller.dart';
import 'cart_controller.dart';

class CheckoutController extends GetxController {
  final ProcessPaymentUseCase _processPayment;
  final PlaceOrderUseCase _placeOrder;

  CheckoutController({
    required ProcessPaymentUseCase processPayment,
    required PlaceOrderUseCase placeOrder,
  })  : _processPayment = processPayment,
        _placeOrder = placeOrder;

  final RxBool isProcessing = false.obs;
  final RxBool paymentSuccess = false.obs;
  final RxString errorMessage = ''.obs;
  final selectedPayment = 0.obs;

  // Shipping form
  final checkoutFormKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final zipCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    nameCtrl.text = Get.find<AuthController>().currentUser.value?.name ?? '';
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    zipCtrl.dispose();
    super.onClose();
  }

  Future<void> processPayment({
    required double amount,
    required String email,
  }) async {
    isProcessing.value = true;
    errorMessage.value = '';

    final cart = Get.find<CartController>();

    final result = await _processPayment(
      amount: amount,
      currency: 'usd',
      email: email,
    );

    await result.fold(
      (failure) async {
        errorMessage.value = failure.message;
        Get.snackbar('Payment Failed', failure.message, snackPosition: SnackPosition.BOTTOM);
      },
      (_) async {
        final paymentMethod = ['Credit Card', 'PayPal', 'Apple Pay'][selectedPayment.value];
        final orderResult = await _placeOrder(
          items: cart.cartItems,
          shippingInfo: {
            'name': nameCtrl.text,
            'address': addressCtrl.text,
            'city': cityCtrl.text,
            'zip': zipCtrl.text,
          },
          paymentMethod: paymentMethod,
          subtotal: cart.subtotal,
          shipping: cart.shipping,
          total: cart.total,
        );
        orderResult.fold(
          (failure) => appLogger.w('[CHECKOUT] Order post failed: ${failure.message}'),
          (order) => appLogger.i('[CHECKOUT] Order placed: ${order.id}'),
        );
        paymentSuccess.value = true;
        cart.clearCart();
      },
    );

    isProcessing.value = false;
  }
}
