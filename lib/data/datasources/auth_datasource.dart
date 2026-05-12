import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_endpoints.dart';
import '../../core/utils/app_logger.dart';
import '../models/user_model.dart';

const _keyToken = 'auth_token';
const _keyUser = 'auth_user';

abstract class AuthDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  String? get token;
  Future<void> clearToken();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String email, String otp, String newPassword);
  Future<void> init();
  Future<UserModel?> getPersistedUser();
}

class ApiAuthDataSource implements AuthDataSource {
  final String baseUrl;
  final SharedPreferences _prefs;
  final http.Client _client;
  String? _token;

  ApiAuthDataSource({required this.baseUrl, required SharedPreferences prefs, http.Client? client})
      : _prefs = prefs,
        _client = client ?? http.Client();

  @override
  String? get token => _token;

  @override
  Future<void> clearToken() async {
    _token = null;
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUser);
  }

  @override
  Future<void> init() async {
    _token = _prefs.getString(_keyToken);
    appLogger.d('[AUTH] init — persisted token ${_token != null ? "found" : "not found"}');
  }

  @override
  Future<UserModel?> getPersistedUser() async {
    final raw = _prefs.getString(_keyUser);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

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
    final data = await _post(AppEndpoints.login, {'email': email, 'password': password});
    _token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    await _prefs.setString(_keyToken, _token!);
    await _prefs.setString(_keyUser, jsonEncode(user.toJson()));
    appLogger.i('[AUTH] Login success — user: ${user.name}');
    return user;
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final data = await _post(AppEndpoints.register, {
      'name': name,
      'email': email,
      'password': password,
    });
    _token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    await _prefs.setString(_keyToken, _token!);
    await _prefs.setString(_keyUser, jsonEncode(user.toJson()));
    appLogger.i('[AUTH] Register success — user: ${user.name}');
    return user;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _post(AppEndpoints.forgotPassword, {'email': email});
  }

  @override
  Future<void> resetPassword(String email, String otp, String newPassword) async {
    await _post(AppEndpoints.resetPassword, {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
    });
  }
}
