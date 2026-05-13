import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../../presentation/bindings/initial_binding.dart';
import '../../presentation/bindings/home_binding.dart';
import '../../presentation/bindings/checkout_binding.dart';
import '../../presentation/bindings/product_detail_binding.dart';
import '../../presentation/bindings/forgot_password_binding.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/auth/forgot_password_page.dart';
import '../../presentation/pages/auth/reset_password_page.dart';
import '../../presentation/pages/main/main_page.dart';
import '../../presentation/pages/products/product_detail_page.dart';
import '../../presentation/pages/checkout/checkout_page.dart';
import '../../presentation/pages/orders/orders_page.dart';
import '../../presentation/bindings/orders_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordPage(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailPage(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutPage(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersPage(),
      binding: OrdersBinding(),
    ),
  ];
}
