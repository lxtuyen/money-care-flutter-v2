import 'package:money_care/core/errors/exceptions.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    final rawMessage = json['message'];
    final String message;
    if (rawMessage is List) {
      message = rawMessage.join(', ');
    } else {
      message = rawMessage?.toString() ?? '';
    }

    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: message,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }

  T unwrap() {
    if (!success) {
      throw ServerException(message);
    }
    if (data == null && null is! T) {
      throw ServerException(
        message.isNotEmpty ? message : 'Response data is null',
      );
    }
    return data as T;
  }
}
