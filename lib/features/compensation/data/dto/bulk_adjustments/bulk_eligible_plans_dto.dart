import 'package:grc/features/compensation/data/dto/compensation_plans/compensation_plan_dto.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/employee_eligible_plans.dart';

class BulkEligiblePlansDto {
  const BulkEligiblePlansDto({required this.entries});

  final List<EmployeeEligiblePlansDto> entries;

  factory BulkEligiblePlansDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    return BulkEligiblePlansDto(
      entries: data.map((e) => EmployeeEligiblePlansDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  List<EmployeeEligiblePlans> toDomain() {
    return entries.map((e) => e.toDomain()).toList();
  }
}

class EmployeeEligiblePlansDto {
  const EmployeeEligiblePlansDto({
    required this.employeeId,
    required this.employeeGuid,
    required this.enterpriseId,
    required this.plans,
  });

  final int employeeId;
  final String employeeGuid;
  final int enterpriseId;
  final List<CompensationPlanDto> plans;

  factory EmployeeEligiblePlansDto.fromJson(Map<String, dynamic> json) {
    final plansJson = json['plans'] as List<dynamic>? ?? [];
    return EmployeeEligiblePlansDto(
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: (json['employee_guid'] as String?) ?? '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      plans: plansJson.map((e) => CompensationPlanDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  EmployeeEligiblePlans toDomain() {
    return EmployeeEligiblePlans(
      employeeId: employeeId,
      employeeGuid: employeeGuid,
      enterpriseId: enterpriseId,
      plans: plans.map((dto) => dto.toDomain()).toList(),
    );
  }
}
