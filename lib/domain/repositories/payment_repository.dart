import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> createPaymentIntent({
    required double amount,
    required String currency,
  });
  Future<Either<Failure, void>> processPayment({
    required String clientSecret,
    required String email,
  });
}
