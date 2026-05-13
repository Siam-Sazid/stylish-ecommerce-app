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
import '../data/datasources/order_datasource.dart';
import '../data/repositories/order_repository_impl.dart';
import '../domain/repositories/order_repository.dart';
import '../domain/usecases/order_usecases.dart';

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs);

  // Auth datasource — permanent so the in-memory token survives navigation cleanup
  final authDataSource = ApiAuthDataSource(baseUrl: AppConfig.baseUrl, prefs: prefs);
  Get.put<AuthDataSource>(authDataSource, permanent: true);

  // Auth repository — permanent so the same instance is always found
  final authRepository = AuthRepositoryImpl(authDataSource);
  Get.put<AuthRepository>(authRepository, permanent: true);

  // Data sources (real API)
  Get.lazyPut<ProductDataSource>(
    () => ApiProductDataSource(baseUrl: AppConfig.baseUrl),
    fenix: true,
  );

  // Repositories
  Get.lazyPut<ProductRepository>(
    () => ProductRepositoryImpl(Get.find<ProductDataSource>()),
    fenix: true,
  );
  Get.lazyPut<CartRepository>(() => CartRepositoryImpl(), fenix: true);
  Get.lazyPut<PaymentRepository>(() => PaymentRepositoryImpl(), fenix: true);
  // Order datasource — passes the permanent authDataSource instance directly
  Get.lazyPut<OrderDataSource>(
    () => ApiOrderDataSource(
      baseUrl: AppConfig.baseUrl,
      authDataSource: authDataSource,
    ),
    fenix: true,
  );

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

  // Order repository + use cases
  Get.lazyPut<OrderRepository>(
    () => OrderRepositoryImpl(Get.find<OrderDataSource>()),
    fenix: true,
  );
  Get.lazyPut(() => GetOrdersUseCase(Get.find<OrderRepository>()), fenix: true);
  Get.lazyPut(() => PlaceOrderUseCase(Get.find<OrderRepository>()), fenix: true);
}
