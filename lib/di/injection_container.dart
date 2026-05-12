import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_config.dart';
import '../data/datasources/product_datasource.dart';
import '../data/datasources/auth_datasource.dart';
import '../data/repositories/product_repository_impl.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/payment_repository_impl.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/payment_repository.dart';
import '../domain/usecases/product_usecases.dart';
import '../domain/usecases/cart_usecases.dart';
import '../domain/usecases/auth_usecases.dart';
import '../domain/usecases/process_payment_usecase.dart';

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs);

  // Data sources (real API)
  Get.lazyPut<ProductDataSource>(
    () => ApiProductDataSource(baseUrl: AppConfig.baseUrl),
    fenix: true,
  );
  Get.lazyPut<AuthDataSource>(
    () => ApiAuthDataSource(baseUrl: AppConfig.baseUrl, prefs: Get.find<SharedPreferences>()),
    fenix: true,
  );

  // Repositories
  Get.lazyPut<ProductRepository>(
    () => ProductRepositoryImpl(Get.find<ProductDataSource>()),
    fenix: true,
  );
  Get.lazyPut<CartRepository>(() => CartRepositoryImpl(), fenix: true);
  Get.lazyPut<AuthRepository>(
    () => AuthRepositoryImpl(Get.find<AuthDataSource>()),
    fenix: true,
  );
  Get.lazyPut<PaymentRepository>(() => PaymentRepositoryImpl(), fenix: true);

  // Product use cases
  Get.lazyPut(() => GetAllProductsUseCase(Get.find<ProductRepository>()), fenix: true);
  Get.lazyPut(() => GetFeaturedProductsUseCase(Get.find<ProductRepository>()), fenix: true);
  Get.lazyPut(() => GetCategoriesUseCase(Get.find<ProductRepository>()), fenix: true);
  Get.lazyPut(() => GetProductsByCategoryUseCase(Get.find<ProductRepository>()), fenix: true);
  Get.lazyPut(() => SearchProductsUseCase(Get.find<ProductRepository>()), fenix: true);
  Get.lazyPut(() => GetProductByIdUseCase(Get.find<ProductRepository>()), fenix: true);

  // Cart use cases
  Get.lazyPut(() => GetCartItemsUseCase(Get.find<CartRepository>()), fenix: true);
  Get.lazyPut(() => AddToCartUseCase(Get.find<CartRepository>()), fenix: true);
  Get.lazyPut(() => RemoveFromCartUseCase(Get.find<CartRepository>()), fenix: true);
  Get.lazyPut(() => UpdateCartQuantityUseCase(Get.find<CartRepository>()), fenix: true);
  Get.lazyPut(() => ClearCartUseCase(Get.find<CartRepository>()), fenix: true);

  // Auth use cases
  Get.lazyPut(() => LoginUseCase(Get.find<AuthRepository>()), fenix: true);
  Get.lazyPut(() => RegisterUseCase(Get.find<AuthRepository>()), fenix: true);
  Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepository>()), fenix: true);
  Get.lazyPut(() => ForgotPasswordUseCase(Get.find<AuthRepository>()), fenix: true);
  Get.lazyPut(() => ResetPasswordUseCase(Get.find<AuthRepository>()), fenix: true);
  Get.lazyPut(() => RestoreSessionUseCase(Get.find<AuthRepository>()), fenix: true);

  // Payment use case
  Get.lazyPut(() => ProcessPaymentUseCase(Get.find<PaymentRepository>()), fenix: true);
}
