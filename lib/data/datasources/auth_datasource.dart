import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/app_logger.dart';
import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  String? get token;
  void clearToken();
}

class ApiAuthDataSource implements AuthDataSource {
  final String baseUrl;
  final http.Client _client;
  String? _token;

  ApiAuthDataSource({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  @override
  String? get token => _token;

  @override
  void clearToken() => _token = null;

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    appLogger.i('[AUTH] POST $uri');
    appLogger.d('[AUTH] Request body: ${jsonEncode(body)}');

    try {
      final res = await _client
          .post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      appLogger.i('[AUTH] Response status: ${res.statusCode}');
      appLogger.d('[AUTH] Response body: ${res.body}');

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode >= 400) {
        final msg = data['message'] ?? 'Request failed (${res.statusCode})';
        appLogger.w('[AUTH] Server error: $msg');
        throw Exception(msg);
      }
      return data;
    } catch (e, stack) {
      appLogger.e('[AUTH] Request failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final data = await _post('/api/auth/login', {'email': email, 'password': password});
    _token = data['token'] as String;
    appLogger.i('[AUTH] Login success — user: ${data['user']['name']}');
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final data = await _post('/api/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
    _token = data['token'] as String;
    appLogger.i('[AUTH] Register success — user: ${data['user']['name']}');
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }
}
