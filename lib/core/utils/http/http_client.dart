import 'package:http/http.dart' as http;
import 'dart:convert';

class AppHttpHelper {
  static const String _baseUrl = 'https://your-api.com/api';

  // Common headers
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ----------------- HTTP METHODS -----------------

  // GET
  static Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  // POST
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.post(
      uri,
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // PUT
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.put(
      uri,
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // DELETE
  static Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.delete(uri, headers: _headers);
    return _handleResponse(response);
  }

  // ----------------- RESPONSE HANDLER -----------------
  static dynamic _handleResponse(http.Response response) {
    try {
      final statusCode = response.statusCode;
      final body = response.body.isNotEmpty ? json.decode(response.body) : null;

      if (statusCode >= 200 && statusCode < 300) {
        return body;
      } else {
        throw HttpException(
          message: body?['message'] ?? 'Unexpected error',
          statusCode: statusCode,
        );
      }
    } catch (e) {
      throw HttpException(message: 'Invalid response format: $e');
    }
  }
}

// ----------------- CUSTOM EXCEPTION -----------------
class HttpException implements Exception {
  final String message;
  final int? statusCode;
  HttpException({required this.message, this.statusCode});

  @override
  String toString() =>
      'HttpException: $message (status: ${statusCode ?? "unknown"})';
}
