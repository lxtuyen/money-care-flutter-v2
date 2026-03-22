import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/network/api_response.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  LocalStorage get _storage => LocalStorage();

  Map<String, String> _headers() {
    final token = _storage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJsonT,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$path'),
      headers: _headers(),
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response, fromJsonT);
  }

  Future<ApiResponse<T>> postMultipart<T>(
    String path, {
    Map<String, dynamic>? fields,
    required XFile file,
    T Function(dynamic)? fromJsonT,
  }) async {
    final token = _storage.getToken();
    final uri = Uri.parse('$baseUrl/$path');
    final request = http.MultipartRequest('POST', uri);

    final headers = {'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    request.headers.addAll(headers);

    if (fields != null) {
      request.fields.addAll(
        fields.map((key, value) => MapEntry(key, value.toString())),
      );
    }

    final bytes = await file.readAsBytes();
    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: file.name),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    return _handleResponse(response, fromJsonT);
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJsonT,
  }) async {
    final uri = Uri.parse('$baseUrl/$path').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
    final response = await http.get(uri, headers: _headers());
    return _handleResponse(response, fromJsonT);
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJsonT,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$path'),
      headers: _headers(),
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response, fromJsonT);
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    T Function(dynamic)? fromJsonT,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$path'),
      headers: _headers(),
    );
    return _handleResponse(response, fromJsonT);
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJsonT,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$path'),
      headers: _headers(),
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response, fromJsonT);
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJsonT,
  ) {
    final body = jsonDecode(response.body);
    return ApiResponse<T>.fromJson(body, fromJsonT);
  }
}
