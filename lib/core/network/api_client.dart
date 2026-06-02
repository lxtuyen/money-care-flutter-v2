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

  Uri _buildUri(String path) {
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('$cleanBase/$cleanPath');
  }

  Map<String, String>? _cleanQueryParams(Map<String, dynamic>? queryParameters) {
    if (queryParameters == null) return null;
    final clean = <String, String>{};
    queryParameters.forEach((key, value) {
      if (value != null) {
        clean[key] = value.toString();
      }
    });
    return clean.isNotEmpty ? clean : null;
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    List<dynamic>? bodyList,
    T Function(dynamic)? fromJsonT,
  }) async {
    final uri = _buildUri(path).replace(
      queryParameters: _cleanQueryParams(queryParameters),
    );
    final response = await http.post(
      uri,
      headers: _headers(),
      body: jsonEncode(bodyList ?? body ?? {}),
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
    final uri = _buildUri(path);
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
    final uri = _buildUri(path).replace(
      queryParameters: _cleanQueryParams(queryParameters),
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
      _buildUri(path),
      headers: _headers(),
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response, fromJsonT);
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJsonT,
  }) async {
    final response = await http.delete(
      _buildUri(path),
      headers: _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response, fromJsonT);
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJsonT,
  }) async {
    final response = await http.patch(
      _buildUri(path),
      headers: _headers(),
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response, fromJsonT);
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJsonT,
  ) {
    final rawBody = response.body.trim();

    if (rawBody.isEmpty) {
      return ApiResponse<T>(
        success: response.statusCode >= 200 && response.statusCode < 300,
        message: '',
      );
    }

    try {
      final decoded = jsonDecode(rawBody);
      if (decoded is Map<String, dynamic>) {
        return ApiResponse<T>.fromJson(decoded, fromJsonT);
      }

      return ApiResponse<T>(
        success: response.statusCode >= 200 && response.statusCode < 300,
        message: '',
        data: fromJsonT != null ? fromJsonT(decoded) : null,
      );
    } catch (_) {
      return ApiResponse<T>(
        success: response.statusCode >= 200 && response.statusCode < 300,
        message: rawBody,
      );
    }
  }
}
