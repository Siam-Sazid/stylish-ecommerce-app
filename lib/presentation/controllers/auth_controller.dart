import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase;

  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Login form state
  final loginFormKey = GlobalKey<FormState>();
  final loginEmailCtrl = TextEditingController();
  final loginPasswordCtrl = TextEditingController();
  final obscureLoginPass = true.obs;

  // Register form state
  final registerFormKey = GlobalKey<FormState>();
  final registerNameCtrl = TextEditingController();
  final registerEmailCtrl = TextEditingController();
  final registerPasswordCtrl = TextEditingController();
  final registerConfirmCtrl = TextEditingController();
  final obscureRegisterPass = true.obs;
  final obscureRegisterConfirm = true.obs;

  bool get isLoggedIn => currentUser.value != null;

  @override
  void onClose() {
    loginEmailCtrl.dispose();
    loginPasswordCtrl.dispose();
    registerNameCtrl.dispose();
    registerEmailCtrl.dispose();
    registerPasswordCtrl.dispose();
    registerConfirmCtrl.dispose();
    super.onClose();
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    appLogger.i('[AuthController] login called — email: $email');

    try {
      final result = await _loginUseCase(email, password);
      result.fold(
        (failure) {
          appLogger.w('[AuthController] login failure: ${failure.message}');
          errorMessage.value = failure.message;
        },
        (user) {
          appLogger.i('[AuthController] login success — navigating to main');
          currentUser.value = user;
          loginEmailCtrl.clear();
          loginPasswordCtrl.clear();
          Get.offAllNamed(AppRoutes.main);
        },
      );
    } catch (e, stack) {
      appLogger.e('[AuthController] login unexpected error', error: e, stackTrace: stack);
      errorMessage.value = 'Unexpected error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    appLogger.i('[AuthController] register called — email: $email');

    try {
      final result = await _registerUseCase(name, email, password);
      result.fold(
        (failure) {
          appLogger.w('[AuthController] register failure: ${failure.message}');
          errorMessage.value = failure.message;
        },
        (user) {
          appLogger.i('[AuthController] register success — navigating to main');
          currentUser.value = user;
          registerNameCtrl.clear();
          registerEmailCtrl.clear();
          registerPasswordCtrl.clear();
          registerConfirmCtrl.clear();
          Get.offAllNamed(AppRoutes.main);
        },
      );
    } catch (e, stack) {
      appLogger.e('[AuthController] register unexpected error', error: e, stackTrace: stack);
      errorMessage.value = 'Unexpected error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
