import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc_web/core/network/network_providers.dart';
import 'package:grc_web/features/dashboard/data/data_sources/dashboard_remote_data_source.dart';
import 'package:grc_web/features/dashboard/data/data_sources/dashboard_remote_data_source_impl.dart';
import 'package:grc_web/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:grc_web/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:grc_web/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:grc_web/features/dashboard/domain/use_cases/get_dashboard_data_use_case.dart';

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSourceImpl(ref.watch(dioProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider));
});

final getDashboardDataUseCaseProvider = Provider<GetDashboardDataUseCase>((ref) {
  return GetDashboardDataUseCase(ref.watch(dashboardRepositoryProvider));
});

class DashboardNotifier extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() async {
    return loadDashboardData();
  }

  Future<DashboardData> loadDashboardData() async {
    final result = await ref.read(getDashboardDataUseCaseProvider)();
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => loadDashboardData());
  }
}

final dashboardDataProvider = AsyncNotifierProvider<DashboardNotifier, DashboardData>(DashboardNotifier.new);
