import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_org_units_by_level_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_positions_by_org_unit_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_positions_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_position_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/update_position_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/delete_position_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_job_families_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_job_family_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_job_levels_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_job_level_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/update_job_level_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/delete_job_level_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_grades_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_grade_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/delete_grade_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/update_grade_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_notifier.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/org_unit_position_notifier.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/time_management/domain/usecases/get_work_schedules_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/update_work_schedule_usecase.dart';
import 'package:grc/features/time_management/domain/usecases/delete_work_schedule_usecase.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeePositionNotifierProvider =
    StateNotifierProvider.family<PositionNotifier, PaginationState<Position>, int?>((ref, enterpriseId) {
      final getPositionsUseCase = ref.watch(employeeGetPositionsUseCaseProvider);
      final createPositionUseCase = ref.watch(employeeCreatePositionUseCaseProvider);
      final updatePositionUseCase = ref.watch(employeeUpdatePositionUseCaseProvider);
      final deletePositionUseCase = ref.watch(employeeDeletePositionUseCaseProvider);

      final notifier = PositionNotifier(
        getPositionsUseCase,
        createPositionUseCase,
        updatePositionUseCase,
        deletePositionUseCase,
        enterpriseId,
      );
      Future.microtask(() => notifier.loadFirstPage());
      return notifier;
    });

typedef AddEmployeePositionByOrgUnitKey = ({int enterpriseId, String orgUnitId});

/// Positions by org unit — add/edit employee assignment step only.
final addEmployeePositionByOrgUnitNotifierProvider =
    StateNotifierProvider.family<OrgUnitPositionNotifier, PaginationState<Position>, AddEmployeePositionByOrgUnitKey>((
      ref,
      key,
    ) {
      final getPositionsByOrgUnitUseCase = ref.watch(employeeGetPositionsByOrgUnitUseCaseProvider);
      final notifier = OrgUnitPositionNotifier(getPositionsByOrgUnitUseCase, key.enterpriseId, key.orgUnitId);
      Future.microtask(() => notifier.loadFirstPage());
      return notifier;
    });

final employeeJobFamilyNotifierProvider =
    StateNotifierProvider.family<JobFamilyNotifier, PaginationState<JobFamily>, int?>((ref, enterpriseId) {
      final getJobFamiliesUseCase = ref.watch(employeeGetJobFamiliesUseCaseProvider);
      final createJobFamilyUseCase = ref.watch(employeeCreateJobFamilyUseCaseProvider);

      final notifier = JobFamilyNotifier(getJobFamiliesUseCase, createJobFamilyUseCase, enterpriseId);
      Future.microtask(() => notifier.loadFirstPage());
      return notifier;
    });

final employeeJobLevelNotifierProvider =
    StateNotifierProvider.family<JobLevelNotifier, PaginationState<JobLevel>, int?>((ref, enterpriseId) {
      final getJobLevelsUseCase = ref.watch(employeeGetJobLevelsUseCaseProvider);
      final createJobLevelUseCase = ref.watch(employeeCreateJobLevelUseCaseProvider);
      final updateJobLevelUseCase = ref.watch(employeeUpdateJobLevelUseCaseProvider);
      final deleteJobLevelUseCase = ref.watch(employeeDeleteJobLevelUseCaseProvider);

      final notifier = JobLevelNotifier(
        getJobLevelsUseCase,
        createJobLevelUseCase,
        updateJobLevelUseCase,
        deleteJobLevelUseCase,
        enterpriseId,
      );
      Future.microtask(() => notifier.loadFirstPage());
      return notifier;
    });

final employeeGradeNotifierProvider = StateNotifierProvider.family<GradeNotifier, GradeState, int?>((
  ref,
  enterpriseId,
) {
  final getGradesUseCase = ref.watch(employeeGetGradesUseCaseProvider);
  final createGradeUseCase = ref.watch(employeeCreateGradeUseCaseProvider);
  final deleteGradeUseCase = ref.watch(employeeDeleteGradeUseCaseProvider);
  final updateGradeUseCase = ref.watch(employeeUpdateGradeUseCaseProvider);

  final notifier = GradeNotifier(
    getGradesUseCase,
    createGradeUseCase,
    deleteGradeUseCase,
    updateGradeUseCase,
    enterpriseId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});

final employeeWorkSchedulesNotifierProvider =
    StateNotifierProvider.family<WorkSchedulesNotifier, WorkScheduleState, int>((ref, enterpriseId) {
      final getWorkSchedulesUseCase = ref.watch(employeeGetWorkSchedulesUseCaseProvider(enterpriseId));
      final updateWorkScheduleUseCase = ref.watch(employeeUpdateWorkScheduleUseCaseProvider(enterpriseId));
      final deleteWorkScheduleUseCase = ref.watch(employeeDeleteWorkScheduleUseCaseProvider(enterpriseId));

      final notifier = WorkSchedulesNotifier(
        getWorkSchedulesUseCase,
        updateWorkScheduleUseCase,
        deleteWorkScheduleUseCase,
        ref,
      );
      notifier.setEnterpriseId(enterpriseId);
      return notifier;
    });

final employeeEnterpriseSelectionNotifierProvider =
    StateNotifierProvider.family<
      EnterpriseSelectionNotifier,
      EnterpriseSelectionState,
      ({List<OrgStructureLevel> levels, String structureId})
    >((ref, params) {
      final tenantId = ref.watch(manageEmployeesEnterpriseIdProvider);
      return EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(employeeGetOrgUnitsByLevelUseCaseProvider),
        levels: params.levels,
        structureId: params.structureId,
        tenantId: tenantId,
      );
    });

// UseCase Wrappers
final employeeGetPositionsUseCaseProvider = Provider<GetPositionsUseCase>((ref) {
  return ref.watch(getPositionsUseCaseProvider);
});
final employeeGetPositionsByOrgUnitUseCaseProvider = Provider<GetPositionsByOrgUnitUseCase>((ref) {
  final repository = ref.watch(positionRepositoryProvider);
  return GetPositionsByOrgUnitUseCase(repository: repository);
});
final employeeCreatePositionUseCaseProvider = Provider<CreatePositionUseCase>((ref) {
  return ref.watch(createPositionUseCaseProvider);
});
final employeeUpdatePositionUseCaseProvider = Provider<UpdatePositionUseCase>((ref) {
  return ref.watch(updatePositionUseCaseProvider);
});
final employeeDeletePositionUseCaseProvider = Provider<DeletePositionUseCase>((ref) {
  return ref.watch(deletePositionUseCaseProvider);
});

final employeeGetJobFamiliesUseCaseProvider = Provider<GetJobFamiliesUseCase>((ref) {
  return ref.watch(getJobFamiliesUseCaseProvider);
});
final employeeCreateJobFamilyUseCaseProvider = Provider<CreateJobFamilyUseCase>((ref) {
  return ref.watch(createJobFamilyUseCaseProvider);
});

final employeeGetJobLevelsUseCaseProvider = Provider<GetJobLevelsUseCase>((ref) {
  return ref.watch(getJobLevelsUseCaseProvider);
});
final employeeCreateJobLevelUseCaseProvider = Provider<CreateJobLevelUseCase>((ref) {
  return ref.watch(createJobLevelUseCaseProvider);
});
final employeeUpdateJobLevelUseCaseProvider = Provider<UpdateJobLevelUseCase>((ref) {
  return ref.watch(updateJobLevelUseCaseProvider);
});
final employeeDeleteJobLevelUseCaseProvider = Provider<DeleteJobLevelUseCase>((ref) {
  return ref.watch(deleteJobLevelUseCaseProvider);
});

final employeeGetGradesUseCaseProvider = Provider<GetGradesUseCase>((ref) {
  return ref.watch(getGradesUseCaseProvider);
});
final employeeCreateGradeUseCaseProvider = Provider<CreateGradeUseCase>((ref) {
  return ref.watch(createGradeUseCaseProvider);
});
final employeeDeleteGradeUseCaseProvider = Provider<DeleteGradeUseCase>((ref) {
  return ref.watch(deleteGradeUseCaseProvider);
});
final employeeUpdateGradeUseCaseProvider = Provider<UpdateGradeUseCase>((ref) {
  return ref.watch(updateGradeUseCaseProvider);
});

final employeeGetActiveOrgStructureLevelsUseCaseProvider = Provider<GetActiveOrgStructureLevelsUseCase>((ref) {
  return ref.watch(getActiveOrgStructureLevelsUseCaseProvider);
});

final employeeGetOrgUnitsByLevelUseCaseProvider = Provider<GetOrgUnitsByLevelUseCase>((ref) {
  return ref.watch(getOrgUnitsByLevelUseCaseProvider);
});

final employeeGetWorkSchedulesUseCaseProvider = Provider.family<GetWorkSchedulesUseCase, int>((ref, enterpriseId) {
  return ref.watch(getWorkSchedulesUseCaseProvider(enterpriseId));
});

final employeeUpdateWorkScheduleUseCaseProvider = Provider.family<UpdateWorkScheduleUseCase, int>((ref, enterpriseId) {
  return ref.watch(updateWorkScheduleUseCaseProvider(enterpriseId));
});

final employeeDeleteWorkScheduleUseCaseProvider = Provider.family<DeleteWorkScheduleUseCase, int>((ref, enterpriseId) {
  return ref.watch(deleteWorkScheduleUseCaseProvider(enterpriseId));
});
