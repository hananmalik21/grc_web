import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:grc/core/network/exceptions.dart';

class UrlBytesFetcher {
  UrlBytesFetcher({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<Uint8List> getBytes(String pathOrFullUrl, {Map<String, String>? headers}) async {
    try {
      final response = await _dio.get<dynamic>(
        pathOrFullUrl,
        options: Options(responseType: ResponseType.bytes, headers: headers),
      );
      if (response.data == null) return Uint8List(0);
      if (response.data is Uint8List) return response.data as Uint8List;
      if (response.data is List<int>) return Uint8List.fromList(response.data as List<int>);
      return Uint8List(0);
    } on DioException catch (e) {
      throw UnknownException(
        e.message ?? 'Failed to fetch bytes',
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    }
  }
}
