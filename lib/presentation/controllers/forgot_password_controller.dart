import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/usecases/auth_usecases.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  ForgotPasswordController({
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _forgotPasswordUseCase = forgotPasswordUseCase,
        _resetPasswordUseCase = resetPasswordUseCase;

  final emailFormKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();

  final resetFormKey = GlobalKey<FormState>();
  final otpCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString submittedEmail = ''.obs;
  final RxBool obscureNewPass = true.obs;
  final RxBool obscureConfirmPass = true.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    otpCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }

  Future<void> sendOtp() async {
    isLoading.value = true;
    errorMessage.value = '';
    appLogger.i('[ForgotPasswordController] sendOtp — email: ${emailCtrl.text.trim()}');

    try {
      final result = await _forgotPasswordUseCase(emailCtrl.text.trim());
      result.fold(
        (failure) {
          appLogger.w('[ForgotPasswordController] sendOtp failure: ${failure.message}');
          errorMessage.value = failure.message;
        },
        (_) {
          submittedEmail.value = emailCtrl.text.trim();
          appLogger.i('[ForgotPasswordController] OTP request sent, navigating to reset page');
          Get.toNamed(AppRoutes.resetPassword);
        },
      );
    } catch (e, stack) {
      appLogger.e('[ForgotPasswordController] sendOtp error', error: e, stackTrace: stack);
      errorMessage.value = 'Unexpected error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    isLoading.value = true;
    errorMessage.value = '';
    appLogger.i('[ForgotPasswordController] resetPassword — email: ${submittedEmail.value}');

    try {
      final result = await _resetPasswordUseCase(
        submittedEmail.value,
        otpCtrl.text.trim(),
        newPasswordCtrl.text,
      );
      result.fold(
        (failure) {
          appLogger.w('[ForgotPasswordController] resetPassword failure: ${failure.message}');
          errorMessage.value = failure.message;
        },
        (_) {
          appLogger.i('[ForgotPasswordController] Password reset success');
          otpCtrl.clear();
          newPasswordCtrl.clear();
          confirmPasswordCtrl.clear();
          submittedEmail.value = '';
          Get.offAllNamed(AppRoutes.login);
          Get.snackbar(
            'Password Reset',
            'Your password was reset successfully. Please sign in.',
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        },
      );
    } catch (e, stack) {
      appLogger.e('[ForgotPasswordController] resetPassword error', error: e, stackTrace: stack);
      errorMessage.value = 'Unexpected error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() {
    otpCtrl.clear();
    errorMessage.value = '';
    Get.back();
  }
}
