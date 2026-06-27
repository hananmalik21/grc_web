import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/eligible_plans_criteria.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plans_page.dart';
import 'package:grc/features/compensation/data/dto/compensation_plans/create_compensation_plan_request_dto.dart';
import 'package:grc/features/compensation/domain/models/employee_compensation/create_employee_compensation_request.dart';

abstract class CompensationPlansRepository {
  Future<CompensationPlansPage> getCompensationPlans({
    required int enterpriseId,
    required int page,
    required int limit,
    String? search,
    String? planTypeCode,
    String? currencyCode,
    String? statusCode,
  });

  Future<CompensationPlan> getCompensationPlanDetail({required String planGuid});
  Future<List<CompensationPlan>> getEligiblePlansForEmployee({required String employeeGuid});
  Future<List<CompensationPlan>> getEligiblePlansByCriteria({required EligiblePlansCriteria criteria});
  Future<List<CompensationPlan>> getEligiblePlansByPosition({required String positionId, required int enterpriseId});
  Future<void> createCompensationPlan({required CreateCompensationPlanRequestDto request});
  Future<void> createEmployeeCompensation({required CreateEmployeeCompensationRequest request});

  Future<void> updateCompensationPlan({required String planGuid, required CreateCompensationPlanRequestDto request});
  Future<void> deleteCompensationPlan({required String planGuid});
}
