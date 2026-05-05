import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
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

  bool get isLoggedIn => currentUser.value != null;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _loginUseCase(email, password);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (user) {
        currentUser.value = user;
        Get.offAllNamed(AppRoutes.main);
      },
    );

    isLoading.value = false;
  }

  Future<void> register(String name, String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _registerUseCase(name, email, password);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (user) {
        currentUser.value = user;
        Get.offAllNamed(AppRoutes.main);
      },
    );

    isLoading.value = false;
  }

  Future<void> logout() async {
    await _logoutUseCase();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
