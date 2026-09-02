import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/cyber_security/data/datasources/cyber_dashboard_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/repositories/cyber_dashboard_repository.dart';

final cyberDashboardApiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(authLocalStorageProvider);
  return ApiClient(baseUrl: ApiConfig.baseUrl, authStorage: storage);
});

final cyberDashboardRemoteDataSourceProvider = Provider<CyberDashboardRemoteDataSource>((ref) {
  final apiClient = ref.watch(cyberDashboardApiClientProvider);
  return DioCyberDashboardRemoteDataSource(apiClient: apiClient);
});

final cyberDashboardRepositoryProvider = Provider<CyberDashboardRepository>((ref) {
  final remoteDataSource = ref.watch(cyberDashboardRemoteDataSourceProvider);
  return CyberDashboardRepositoryImpl(remoteDataSource: remoteDataSource);
});

class CyberDashboardNotifier extends StateNotifier<AsyncValue<CyberDashboardData>> {
  CyberDashboardNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDashboard();
  }

  final CyberDashboardRepository _repository;

  Future<void> loadDashboard() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDashboardData();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    try {
      final data = await _repository.getDashboardData();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final cyberDashboardProvider =
    StateNotifierProvider<CyberDashboardNotifier, AsyncValue<CyberDashboardData>>((ref) {
  final repository = ref.watch(cyberDashboardRepositoryProvider);
  return CyberDashboardNotifier(repository);
});
