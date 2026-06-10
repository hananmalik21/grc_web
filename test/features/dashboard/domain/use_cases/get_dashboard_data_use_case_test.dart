import 'package:flutter_test/flutter_test.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:grc_web/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:grc_web/features/dashboard/domain/use_cases/get_dashboard_data_use_case.dart';

class _FakeDashboardRepositorySuccess implements DashboardRepository {
  @override
  Future<Result<DashboardData>> getDashboardData() async {
    return const Success(
      DashboardData(
        stats: [],
        topRiskAssets: [],
        summaryCards: [
          SummaryCardItem(type: SummaryCardType.cloudWorkloads, value: '1', iconAsset: ''),
        ],
      ),
    );
  }
}

class _FakeDashboardRepositoryFailure implements DashboardRepository {
  @override
  Future<Result<DashboardData>> getDashboardData() async {
    return const FailureResult(NetworkFailure(message: 'server error'));
  }
}

void main() {
  test('GetDashboardDataUseCase returns data on success', () async {
    final useCase = GetDashboardDataUseCase(_FakeDashboardRepositorySuccess());

    final result = await useCase();

    expect(
      result.when(
        success: (data) => data.summaryCards.length,
        failure: (_) => null,
      ),
      1,
    );
  });

  test('GetDashboardDataUseCase returns failure on error', () async {
    final useCase = GetDashboardDataUseCase(_FakeDashboardRepositoryFailure());

    final result = await useCase();

    expect(
      result.when(
        success: (_) => null,
        failure: (f) => f.message,
      ),
      'server error',
    );
  });
}
