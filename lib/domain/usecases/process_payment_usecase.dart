import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/payment_repository.dart';

class ProcessPaymentUseCase {
  final PaymentRepository repository;
  ProcessPaymentUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required double amount,
    required String currency,
    required String email,
  }) async {
    final intentResult = await repository.createPaymentIntent(
      amount: amount,
      currency: currency,
    );
    return intentResult.fold(
      Left.new,
      (clientSecret) => repository.processPayment(
        clientSecret: clientSecret,
        email: email,
      ),
    );
  }
}
