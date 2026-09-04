import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/cyber_security/data/datasources/telemetry_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/cyber_paged_dto.dart';
import 'package:grc/features/cyber_security/data/models/telemetry_dto.dart';
import 'package:grc/features/cyber_security/data/repositories/telemetry_repository.dart';

final telemetryApiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    baseUrl: ApiConfig.baseUrl,
    authStorage: ref.watch(authLocalStorageProvider),
  ),
);

final telemetryRepositoryProvider = Provider<TelemetryRepository>(
  (ref) => TelemetryRepositoryImpl(
    remoteDataSource: DioTelemetryRemoteDataSource(
      apiClient: ref.watch(telemetryApiClientProvider),
    ),
  ),
);

final telemetryLogsProvider = FutureProvider<CyberPagedDto<TelemetryLogDto>>(
  (ref) => ref.watch(telemetryRepositoryProvider).getLogs(),
);
