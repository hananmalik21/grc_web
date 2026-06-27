import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/payroll/data/datasources/element_entries_remote_data_source.dart';
import 'package:grc/features/payroll/data/repositories/element_entries_repository_impl.dart';
import 'package:grc/features/payroll/domain/repositories/element_entries_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _elementEntriesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final elementEntriesRemoteDataSourceProvider = Provider<ElementEntriesRemoteDataSource>((ref) {
  return ElementEntriesRemoteDataSourceImpl(apiClient: ref.watch(_elementEntriesApiClientProvider));
});

final elementEntriesRepositoryProvider = Provider<ElementEntriesRepository>((ref) {
  return ElementEntriesRepositoryImpl(remoteDataSource: ref.watch(elementEntriesRemoteDataSourceProvider));
});
