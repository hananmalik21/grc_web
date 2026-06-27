import 'package:dio/dio.dart';

/// Returns a user-facing message from a [DioException], preferring the API
/// response body (`message`, then `error`) over Dio's verbose status text.
String dioErrorMessage(
  DioException error, {
  String fallback = 'Network error',
}) {
  final data = error.response?.data;

  if (data is Map) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    final apiError = data['error'];
    if (apiError is String && apiError.trim().isNotEmpty) {
      return apiError.trim();
    }
  }

  if (data is String && data.trim().isNotEmpty) {
    return data.trim();
  }

  return fallback;
}
