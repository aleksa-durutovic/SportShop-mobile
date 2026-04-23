import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import 'auth_service.dart';

class OrderService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  final AuthService _authService = AuthService();

  Future<void> createOrder({
    required int totalPrice,
    String status = 'processing',
  }) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Nisi prijavljen.');
    }

    try {
      await _dio.post(
        ApiConstants.orders,
        data: {
          'total_price': totalPrice,
          'status': status,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  Future<List<Map<String, dynamic>>> getMyOrders() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Nisi prijavljen.');
    }

    try {
      final response = await _dio.get(
        ApiConstants.orders,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data;
      if (data is List) {
        return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  Future<void> deleteOrder(int id) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Nisi prijavljen.');
    }

    try {
      await _dio.delete(
        '${ApiConstants.orders}/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      if (data['message'] is String) return data['message'] as String;

      if (data['errors'] is Map<String, dynamic>) {
        final errors = data['errors'] as Map<String, dynamic>;
        if (errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) return first.first.toString();
          return first.toString();
        }
      }
    }

    return e.message ?? 'Došlo je do greške pri komunikaciji sa serverom.';
  }
}