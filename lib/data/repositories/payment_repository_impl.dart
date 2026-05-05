import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  // Base URL for your Node.js backend (update when backend is ready)
  static const String _baseUrl = 'http://localhost:3000/api';

  @override
  Future<Either<Failure, String>> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      // TODO: Replace mock with real backend call when Node.js API is ready:
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/payment/create-intent'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'amount': (amount * 100).toInt(), 'currency': currency}),
      // );
      // final data = jsonDecode(response.body);
      // return Right(data['clientSecret']);

      await Future.delayed(const Duration(seconds: 1));
      // Mock client secret for UI development
      return const Right('pi_mock_secret_for_ui_development');
    } catch (e) {
      return Left(PaymentFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> processPayment({
    required String clientSecret,
    required String email,
  }) async {
    try {
      // TODO: Uncomment when backend provides real Stripe client secret:
      // await Stripe.instance.initPaymentSheet(
      //   paymentSheetParameters: SetupPaymentSheetParameters(
      //     paymentIntentClientSecret: clientSecret,
      //     merchantDisplayName: 'ShopEase',
      //     billingDetails: BillingDetails(email: email),
      //     style: ThemeMode.system,
      //   ),
      // );
      // await Stripe.instance.presentPaymentSheet();

      // Mock payment processing for UI development
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    } catch (e) {
      return Left(PaymentFailure(e.toString()));
    }
  }
}
