import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  UserEntity? _currentUser;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final user = await dataSource.login(email, password);
      _currentUser = user;
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await dataSource.register(name, email, password);
      _currentUser = user;
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    dataSource.clearToken();
  }

  @override
  UserEntity? getCurrentUser() => _currentUser;

  @override
  Future<Either<Failure, Unit>> forgotPassword(String email) async {
    try {
      await dataSource.forgotPassword(email);
      return Right(unit);
    } catch (e) {
      return Left(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(String email, String otp, String newPassword) async {
    try {
      await dataSource.resetPassword(email, otp, newPassword);
      return Right(unit);
    } catch (e) {
      return Left(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
