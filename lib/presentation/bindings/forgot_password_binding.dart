import 'package:get/get.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(
        forgotPasswordUseCase: Get.find<ForgotPasswordUseCase>(),
        resetPasswordUseCase: Get.find<ResetPasswordUseCase>(),
      ),
      fenix: true,
    );
  }
}
