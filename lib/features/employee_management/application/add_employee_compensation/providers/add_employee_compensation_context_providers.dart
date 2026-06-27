import 'package:grc/features/compensation/domain/models/compensation_plans/eligible_plans_criteria.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_job_employment_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addEmployeeEligiblePlansCriteriaProvider = Provider<EligiblePlansCriteria?>((ref) {
  final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
  final job = ref.watch(addEmployeeJobEmploymentProvider);
  final assignment = ref.watch(addEmployeeAssignmentProvider);

  final position = job.selectedPosition;
  final gradeId = job.selectedGrade?.id ?? position?.gradeRef?.id ?? position?.gradeId;
  final positionId = position?.id.trim();
  final jobFamilyId = job.selectedJobFamily?.id ?? position?.jobFamilyRef?.id ?? position?.jobFamilyId;
  final orgUnitId = assignment.businessUnitOrgUnitId?.trim();

  if (enterpriseId == null ||
      gradeId == null ||
      positionId == null ||
      positionId.isEmpty ||
      jobFamilyId == null ||
      orgUnitId == null ||
      orgUnitId.isEmpty) {
    return null;
  }

  return EligiblePlansCriteria(
    enterpriseId: enterpriseId,
    gradeId: gradeId,
    positionId: positionId,
    jobFamilyId: jobFamilyId,
    orgUnitId: orgUnitId,
  );
});
