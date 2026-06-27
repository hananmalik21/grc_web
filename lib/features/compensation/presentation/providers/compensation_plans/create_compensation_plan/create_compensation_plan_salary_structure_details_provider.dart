import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/salary_structure_management/salary_structure_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/salary_structure_management/salary_structure_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_details.dart';
import 'package:grc/features/compensation/domain/repositories/salary_structure_management/salary_structure_repository.dart';
import 'package:grc/features/compensation/domain/usecases/salary_structure_management/get_salary_structure_details_usecase.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _createCompensationPlanSalaryStructureDetailsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _createCompensationPlanSalaryStructureDetailsRemoteDataSourceProvider = Provider<SalaryStructureRemoteDataSource>(
  (ref) {
    return SalaryStructureRemoteDataSourceImpl(
      apiClient: ref.watch(_createCompensationPlanSalaryStructureDetailsApiClientProvider),
    );
  },
);

final _createCompensationPlanSalaryStructureDetailsRepositoryProvider = Provider<SalaryStructureRepository>((ref) {
  return SalaryStructureRepositoryImpl(
    remoteDataSource: ref.watch(_createCompensationPlanSalaryStructureDetailsRemoteDataSourceProvider),
  );
});

final _createCompensationPlanGetSalaryStructureDetailsUseCaseProvider = Provider<GetSalaryStructureDetailsUseCase>((
  ref,
) {
  return GetSalaryStructureDetailsUseCase(
    repository: ref.watch(_createCompensationPlanSalaryStructureDetailsRepositoryProvider),
  );
});

final createCompensationPlanSalaryStructureDetailsProvider = FutureProvider.autoDispose<SalaryStructureDetails?>(
  dependencies: [createCompensationPlanProvider],
  (ref) async {
    final enterpriseId = ref.watch(compensationPlansTabEnterpriseIdProvider);
    final selectedGuid = ref.watch(createCompensationPlanProvider.select((state) => state.selectedSalaryStructureGuid));

    if (enterpriseId == null || selectedGuid == null || selectedGuid.trim().isEmpty) {
      return null;
    }

    final useCase = ref.watch(_createCompensationPlanGetSalaryStructureDetailsUseCaseProvider);
    return useCase(enterpriseId: enterpriseId, structureGuid: selectedGuid);
  },
);
