import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
}

class MockAuthDataSource implements AuthDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isEmpty || password.length < 6) {
      throw Exception('Invalid credentials');
    }
    return UserModel(
      id: 'user_001',
      name: 'John Doe',
      email: email,
      avatarUrl: 'https://picsum.photos/seed/johndoe/200/200',
      phone: '+1 234 567 8900',
      address: '123 Main St, New York, NY 10001',
    );
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (name.isEmpty || email.isEmpty || password.length < 6) {
      throw Exception('Invalid registration data');
    }
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      avatarUrl: 'https://picsum.photos/seed/newuser/200/200',
    );
  }
}
