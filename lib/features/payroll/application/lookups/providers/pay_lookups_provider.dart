import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/payroll/data/datasources/pay_lookups_remote_data_source.dart';
import 'package:grc/features/payroll/data/repositories/pay_lookups_repository_impl.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_value.dart';
import 'package:grc/features/payroll/domain/repositories/pay_lookups_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _payLookupsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final payLookupsRemoteDataSourceProvider = Provider<PayLookupsRemoteDataSource>((ref) {
  return PayLookupsRemoteDataSourceImpl(apiClient: ref.watch(_payLookupsApiClientProvider));
});

final payLookupsRepositoryProvider = Provider<PayLookupsRepository>((ref) {
  return PayLookupsRepositoryImpl(remoteDataSource: ref.watch(payLookupsRemoteDataSourceProvider));
});

final payLookupValuesForTypeProvider =
    FutureProvider.family<List<PayLookupValue>, ({int enterpriseId, String typeCode, int page, int limit})>((
      ref,
      params,
    ) async {
      if (params.enterpriseId <= 0) return const [];

      final repository = ref.watch(payLookupsRepositoryProvider);
      return repository.getLookupValues(
        enterpriseId: params.enterpriseId,
        typeCode: params.typeCode,
        page: params.page,
        limit: params.limit,
      );
    });
