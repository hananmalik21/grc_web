import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/exceptions.dart';

abstract class SpreadsheetExportRemoteDataSource {
  Future<Uint8List> fetchExportBytes({required String endpoint, Map<String, String>? queryParameters});
}

class SpreadsheetExportRemoteDataSourceImpl implements SpreadsheetExportRemoteDataSource {
  SpreadsheetExportRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<Uint8List> fetchExportBytes({required String endpoint, Map<String, String>? queryParameters}) async {
    try {
      final response = await apiClient.dio.get<dynamic>(
        endpoint,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.bytes),
      );

      final failureMessage = _parseExportFailureMessage(response.data);
      if (failureMessage != null) {
        throw UnknownException(failureMessage, statusCode: response.statusCode);
      }

      final data = response.data;
      if (data == null) return Uint8List(0);
      if (data is Uint8List) return data;
      if (data is List<int>) return Uint8List.fromList(data);
      return Uint8List(0);
    } on DioException catch (e) {
      final failureMessage = _parseExportFailureMessage(e.response?.data);
      if (failureMessage != null) {
        throw UnknownException(failureMessage, statusCode: e.response?.statusCode, originalError: e);
      }
      final message = e.response?.statusMessage ?? e.message ?? 'Failed to export file';
      throw UnknownException(message, statusCode: e.response?.statusCode, originalError: e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to export file: ${e.toString()}', originalError: e);
    }
  }
}

String? _parseExportFailureMessage(dynamic data) {
  final json = _decodeExportResponseJson(data);
  if (json == null || json['success'] != false) return null;

  final message = json['message'];
  if (message is String && message.trim().isNotEmpty) {
    return message.trim();
  }
  return 'Failed to export file';
}

Map<String, dynamic>? _decodeExportResponseJson(dynamic data) {
  if (data == null) return null;

  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);

  String? text;
  if (data is String) {
    text = data;
  } else if (data is Uint8List) {
    if (data.isEmpty || !_looksLikeJsonBytes(data)) return null;
    text = _tryDecodeUtf8(data);
  } else if (data is List<int>) {
    if (data.isEmpty) return null;
    final bytes = Uint8List.fromList(data);
    if (!_looksLikeJsonBytes(bytes)) return null;
    text = _tryDecodeUtf8(bytes);
  }

  if (text == null) return null;

  final trimmed = text.trimLeft();
  if (!trimmed.startsWith('{')) return null;

  try {
    final decoded = jsonDecode(text);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
  } catch (_) {
    return null;
  }

  return null;
}

bool _looksLikeJsonBytes(Uint8List bytes) {
  for (final byte in bytes) {
    if (byte == 0x7B) return true;
    if (byte != 0x20 && byte != 0x09 && byte != 0x0A && byte != 0x0D) {
      return false;
    }
  }
  return false;
}

String? _tryDecodeUtf8(Uint8List bytes) {
  try {
    return utf8.decode(bytes);
  } on FormatException {
    return null;
  }
}
