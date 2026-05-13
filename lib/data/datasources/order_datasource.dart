import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_endpoints.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../datasources/auth_datasource.dart';
import '../models/order_model.dart';

abstract class OrderDataSource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> placeOrder({
    required List<CartItemEntity> items,
    required Map<String, String> shippingInfo,
    required String paymentMethod,
    required double subtotal,
    required double shipping,
    required double total,
  });
}

class ApiOrderDataSource implements OrderDataSource {
  final String baseUrl;
  final AuthDataSource _authDataSource;
  final http.Client _client;

  ApiOrderDataSource({
    required this.baseUrl,
    required AuthDataSource authDataSource,
    http.Client? client,
  })  : _authDataSource = authDataSource,
        _client = client ?? http.Client();

  Map<String, String> get _headers {
    final token = _authDataSource.token;
    appLogger.d('[ORDERS] token ${token != null ? "present" : "null"}');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final uri = Uri.parse('$baseUrl${AppEndpoints.orders}');
    appLogger.i('[ORDERS] GET $uri');
    final res = await _client
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (res.statusCode >= 400) throw Exception('Failed to fetch orders (${res.statusCode})');
    final data = jsonDecode(res.body) as List;
    return data.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<OrderModel> placeOrder({
    required List<CartItemEntity> items,
    required Map<String, String> shippingInfo,
    required String paymentMethod,
    required double subtotal,
    required double shipping,
    required double total,
  }) async {
    final uri = Uri.parse('$baseUrl${AppEndpoints.orders}');
    appLogger.i('[ORDERS] POST $uri');
    final body = jsonEncode({
      'items': items.map((e) => OrderItemModel.fromCartItem(e).toJson()).toList(),
      'shippingInfo': shippingInfo,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'shipping': shipping,
      'total': total,
    });
    final res = await _client
        .post(uri, headers: _headers, body: body)
        .timeout(const Duration(seconds: 10));
    if (res.statusCode >= 400) throw Exception('Failed to place order (${res.statusCode})');
    return OrderModel.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
