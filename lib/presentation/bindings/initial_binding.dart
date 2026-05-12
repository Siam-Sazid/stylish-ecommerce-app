import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/cart_usecases.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(
      AuthController(
        loginUseCase: LoginUseCase(Get.find<AuthRepository>()),
        registerUseCase: RegisterUseCase(Get.find<AuthRepository>()),
        logoutUseCase: LogoutUseCase(Get.find<AuthRepository>()),
        restoreSessionUseCase: RestoreSessionUseCase(Get.find<AuthRepository>()),
      ),
      permanent: true,
    );

    Get.put<CartController>(
      CartController(
        addToCart: AddToCartUseCase(Get.find<CartRepository>()),
        removeFromCart: RemoveFromCartUseCase(Get.find<CartRepository>()),
        updateQuantity: UpdateCartQuantityUseCase(Get.find<CartRepository>()),
        getCartItems: GetCartItemsUseCase(Get.find<CartRepository>()),
        clearCart: ClearCartUseCase(Get.find<CartRepository>()),
      ),
      permanent: true,
    );
  }
}
