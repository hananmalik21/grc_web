import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_notifier.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'manage_salary_structure_enterprise_provider.dart';

final salaryStructureJobFamilyNotifierProvider =
    StateNotifierProvider.autoDispose<JobFamilyNotifier, PaginationState<JobFamily>>((ref) {
      final tenantId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
      final notifier = JobFamilyNotifier(
        ref.watch(getJobFamiliesUseCaseProvider),
        ref.watch(createJobFamilyUseCaseProvider),
        tenantId,
      );
      Future.microtask(() => notifier.loadFirstPage());
      return notifier;
    });

final salaryStructureGradeNotifierProvider = StateNotifierProvider.autoDispose<GradeNotifier, GradeState>((ref) {
  final tenantId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
  final notifier = GradeNotifier(
    ref.watch(getGradesUseCaseProvider),
    ref.watch(createGradeUseCaseProvider),
    ref.watch(deleteGradeUseCaseProvider),
    ref.watch(updateGradeUseCaseProvider),
    tenantId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});

final salaryStructurePositionNotifierProvider =
    StateNotifierProvider.autoDispose<PositionNotifier, PaginationState<Position>>((ref) {
      final tenantId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
      final notifier = PositionNotifier(
        ref.watch(getPositionsUseCaseProvider),
        ref.watch(createPositionUseCaseProvider),
        ref.watch(updatePositionUseCaseProvider),
        ref.watch(deletePositionUseCaseProvider),
        tenantId,
      );
      Future.microtask(() => notifier.loadFirstPage());
      return notifier;
    });
