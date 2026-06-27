import 'package:intl/intl.dart';
import '../../../domain/models/adjustments/salary_change_history.dart';
import 'adjustment_dto.dart';

class SalaryChangeHistoryResponseDto {
  final bool success;
  final SalaryChangeHistorySummaryDto summary;
  final List<SalaryChangeHistoryEntryDto> data;
  final PaginationDto pagination;

  SalaryChangeHistoryResponseDto({
    required this.success,
    required this.summary,
    required this.data,
    required this.pagination,
  });

  factory SalaryChangeHistoryResponseDto.fromJson(Map<String, dynamic> json) {
    return SalaryChangeHistoryResponseDto(
      success: json['success'] ?? false,
      summary: SalaryChangeHistorySummaryDto.fromJson(json['summary'] ?? {}),
      data: (json['data'] as List?)?.map((e) => SalaryChangeHistoryEntryDto.fromJson(e)).toList() ?? [],
      pagination: PaginationDto.fromJson(json['pagination'] ?? {}),
    );
  }

  SalaryChangeHistoryPage toDomain() {
    return SalaryChangeHistoryPage(
      summary: summary.toDomain(),
      data: data.map((e) => e.toDomain()).toList(),
      pagination: SalaryChangeHistoryPagination(
        page: pagination.page,
        limit: pagination.limit,
        total: pagination.total,
        totalPages: pagination.totalPages,
        hasNext: pagination.hasNext,
        hasPrevious: pagination.hasPrevious,
      ),
    );
  }
}

class SalaryChangeHistorySummaryDto {
  final int employeeCount;
  final dynamic totalImpact;
  final String currencyCode;

  SalaryChangeHistorySummaryDto({required this.employeeCount, required this.totalImpact, required this.currencyCode});

  factory SalaryChangeHistorySummaryDto.fromJson(Map<String, dynamic> json) {
    return SalaryChangeHistorySummaryDto(
      employeeCount: json['employee_count'] ?? 0,
      totalImpact: json['total_impact'] ?? 0,
      currencyCode: json['currency_code'] ?? '',
    );
  }

  SalaryChangeHistorySummary toDomain() {
    final impactValue = (totalImpact is num) ? totalImpact.toDouble() : 0.0;
    final currencyFormatter = NumberFormat.currency(symbol: '$currencyCode ');

    return SalaryChangeHistorySummary(
      employeeCount: employeeCount,
      totalImpact: impactValue,
      currencyCode: currencyCode,
      displayTotalImpact: currencyFormatter.format(impactValue),
    );
  }
}

class SalaryChangeHistoryEntryDto {
  final int enterpriseId;
  final int employeeId;
  final String employeeGuid;
  final String employeeNameEn;
  final String employeeNumber;
  final String positionName;
  final String gradeName;
  final List<AdjustmentOrgUnitDto> orgStructureList;
  final int? adjustmentId;
  final String? adjustmentType;
  final String? reasonCode;
  final String? submissionDate;
  final String changeSource;
  final String currencyCode;
  final String changeEffectiveDate;
  final dynamic previousSalary;
  final dynamic currentSalary;
  final dynamic impactAmount;
  final dynamic impactPercent;
  final dynamic totalEarnings;
  final dynamic totalAllowances;
  final dynamic totalBenefits;
  final dynamic totalBonuses;
  final dynamic totalDeductions;
  final String changeType;
  final String status;
  final int componentCount;
  final List<SalaryChangeHistoryComponentDto> components;

  SalaryChangeHistoryEntryDto({
    required this.enterpriseId,
    required this.employeeId,
    required this.employeeGuid,
    required this.employeeNameEn,
    required this.employeeNumber,
    required this.positionName,
    required this.gradeName,
    required this.orgStructureList,
    this.adjustmentId,
    this.adjustmentType,
    this.reasonCode,
    this.submissionDate,
    required this.changeSource,
    required this.currencyCode,
    required this.changeEffectiveDate,
    required this.previousSalary,
    required this.currentSalary,
    required this.impactAmount,
    required this.impactPercent,
    required this.totalEarnings,
    required this.totalAllowances,
    required this.totalBenefits,
    required this.totalBonuses,
    required this.totalDeductions,
    required this.changeType,
    required this.status,
    required this.componentCount,
    required this.components,
  });

  factory SalaryChangeHistoryEntryDto.fromJson(Map<String, dynamic> json) {
    return SalaryChangeHistoryEntryDto(
      enterpriseId: json['enterprise_id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      employeeGuid: json['employee_guid'] ?? '',
      employeeNameEn: json['employee_name_en'] ?? '',
      employeeNumber: json['employee_number'] ?? '',
      positionName: json['position_name'] ?? '',
      gradeName: json['grade_name'] ?? '',
      orgStructureList:
          (json['org_structure_list'] as List?)?.map((e) => AdjustmentOrgUnitDto.fromJson(e)).toList() ?? [],
      adjustmentId: json['adjustment_id'],
      adjustmentType: json['adjustment_type'],
      reasonCode: json['reason_code'],
      submissionDate: json['submission_date'],
      changeSource: json['change_source'] ?? '',
      currencyCode: json['currency_code'] ?? '',
      changeEffectiveDate: json['change_effective_date'] ?? '',
      previousSalary: json['previous_salary'] ?? 0,
      currentSalary: json['current_salary'] ?? 0,
      impactAmount: json['impact_amount'] ?? 0,
      impactPercent: json['impact_percent'] ?? 0,
      totalEarnings: json['total_earnings'] ?? 0,
      totalAllowances: json['total_allowances'] ?? 0,
      totalBenefits: json['total_benefits'] ?? 0,
      totalBonuses: json['total_bonuses'] ?? 0,
      totalDeductions: json['total_deductions'] ?? 0,
      changeType: json['change_type'] ?? '',
      status: json['status'] ?? '',
      componentCount: json['component_count'] ?? 0,
      components: (json['components'] as List?)?.map((e) => SalaryChangeHistoryComponentDto.fromJson(e)).toList() ?? [],
    );
  }

  SalaryChangeHistoryEntry toDomain() {
    final prevScaled = (previousSalary is num) ? previousSalary.toDouble() : 0.0;
    final currScaled = (currentSalary is num) ? currentSalary.toDouble() : 0.0;
    final impactAmt = (impactAmount is num) ? impactAmount.toDouble() : 0.0;
    final impactPct = (impactPercent is num) ? impactPercent.toDouble() : 0.0;

    final currencyFormatter = NumberFormat.currency(symbol: '$currencyCode ', decimalDigits: 2);
    final dateFormatter = DateFormat('dd MMM yyyy');
    final parsedEffectiveDate = DateTime.tryParse(changeEffectiveDate) ?? DateTime.now();

    return SalaryChangeHistoryEntry(
      enterpriseId: enterpriseId,
      employeeId: employeeId,
      employeeGuid: employeeGuid,
      employeeNameEn: employeeNameEn,
      employeeNumber: employeeNumber,
      positionName: positionName,
      gradeName: gradeName,
      orgStructureList: orgStructureList.map((e) => e.toDomain()).toList(),
      adjustmentId: adjustmentId,
      adjustmentType: adjustmentType,
      reasonCode: reasonCode,
      submissionDate: submissionDate != null ? DateTime.tryParse(submissionDate!) : null,
      changeSource: changeSource,
      currencyCode: currencyCode,
      changeEffectiveDate: parsedEffectiveDate,
      previousSalary: prevScaled,
      currentSalary: currScaled,
      impactAmount: impactAmt,
      impactPercent: impactPct,
      totalEarnings: (totalEarnings is num) ? totalEarnings.toDouble() : 0.0,
      totalAllowances: (totalAllowances is num) ? totalAllowances.toDouble() : 0.0,
      totalBenefits: (totalBenefits is num) ? totalBenefits.toDouble() : 0.0,
      totalBonuses: (totalBonuses is num) ? totalBonuses.toDouble() : 0.0,
      totalDeductions: (totalDeductions is num) ? totalDeductions.toDouble() : 0.0,
      changeType: changeType,
      isIncrease: impactAmt > 0,
      isDecrease: impactAmt < 0,
      status: status,
      componentCount: componentCount,
      components: components.map((e) => e.toDomain()).toList(),
      displayChangeId: adjustmentId != null ? 'CHG-$adjustmentId' : '-',
      displayEffectiveDate: dateFormatter.format(parsedEffectiveDate),
      formattedPreviousSalary: currencyFormatter.format(prevScaled),
      formattedCurrentSalary: currencyFormatter.format(currScaled),
      formattedImpactAmount: '${impactAmt < 0 ? "- " : ""}${currencyFormatter.format(impactAmt.abs())}',
      formattedImpactPercent: '${impactPct < 0 ? "- " : ""}${impactPct.abs().toStringAsFixed(2)}%',
    );
  }
}

class SalaryChangeHistoryComponentDto {
  final int componentId;
  final String componentCode;
  final String componentName;
  final String componentTypeCode;
  final String compCategoryCode;
  final dynamic amount;

  SalaryChangeHistoryComponentDto({
    required this.componentId,
    required this.componentCode,
    required this.componentName,
    required this.componentTypeCode,
    required this.compCategoryCode,
    required this.amount,
  });

  factory SalaryChangeHistoryComponentDto.fromJson(Map<String, dynamic> json) {
    return SalaryChangeHistoryComponentDto(
      componentId: json['component_id'] ?? 0,
      componentCode: json['component_code'] ?? '',
      componentName: json['component_name'] ?? '',
      componentTypeCode: json['component_type_code'] ?? '',
      compCategoryCode: json['comp_category_code'] ?? '',
      amount: json['amount'] ?? 0,
    );
  }

  SalaryChangeHistoryComponent toDomain() {
    return SalaryChangeHistoryComponent(
      componentId: componentId,
      componentCode: componentCode,
      componentName: componentName,
      componentTypeCode: componentTypeCode,
      compCategoryCode: compCategoryCode,
      amount: (amount is num) ? amount.toDouble() : 0.0,
    );
  }
}
