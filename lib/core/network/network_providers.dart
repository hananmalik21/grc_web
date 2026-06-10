import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc_web/core/constants/app_constants.dart';
import 'package:grc_web/core/network/dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(baseUrl: AppConstants.apiBaseUrl);
});

final dioProvider = Provider<Dio>((ref) => ref.watch(dioClientProvider).dio);

