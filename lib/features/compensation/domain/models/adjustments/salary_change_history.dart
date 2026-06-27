import 'adjustment.dart';

class SalaryChangeHistoryPage {
  final SalaryChangeHistorySummary summary;
  final List<SalaryChangeHistoryEntry> data;
  final SalaryChangeHistoryPagination pagination;

  const SalaryChangeHistoryPage({required this.summary, required this.data, required this.pagination});
}

class SalaryChangeHistorySummary {
  final int employeeCount;
  final double totalImpact;
  final String currencyCode;
  final String displayTotalImpact;

  const SalaryChangeHistorySummary({
    required this.employeeCount,
    required this.totalImpact,
    required this.currencyCode,
    required this.displayTotalImpact,
  });
}

class SalaryChangeHistoryEntry {
  final int enterpriseId;
  final int employeeId;
  final String employeeGuid;
  final String employeeNameEn;
  final String employeeNumber;
  final String positionName;
  final String gradeName;
  final List<AdjustmentOrgUnit> orgStructureList;
  final int? adjustmentId;
  final String? adjustmentType;
  final String? reasonCode;
  final DateTime? submissionDate;
  final String changeSource;
  final String currencyCode;
  final DateTime changeEffectiveDate;
  final double previousSalary;
  final double currentSalary;
  final double impactAmount;
  final double impactPercent;
  final double totalEarnings;
  final double totalAllowances;
  final double totalBenefits;
  final double totalBonuses;
  final double totalDeductions;
  final String changeType;
  final String status;
  final int componentCount;
  final List<SalaryChangeHistoryComponent> components;

  final String displayChangeId;
  final String displayEffectiveDate;
  final String formattedPreviousSalary;
  final String formattedCurrentSalary;
  final String formattedImpactAmount;
  final String formattedImpactPercent;
  final bool isIncrease;
  final bool isDecrease;

  const SalaryChangeHistoryEntry({
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
    required this.displayChangeId,
    required this.displayEffectiveDate,
    required this.formattedPreviousSalary,
    required this.formattedCurrentSalary,
    required this.formattedImpactAmount,
    required this.formattedImpactPercent,
    required this.isIncrease,
    required this.isDecrease,
  });
}

class SalaryChangeHistoryComponent {
  final int componentId;
  final String componentCode;
  final String componentName;
  final String componentTypeCode;
  final String compCategoryCode;
  final double amount;

  const SalaryChangeHistoryComponent({
    required this.componentId,
    required this.componentCode,
    required this.componentName,
    required this.componentTypeCode,
    required this.compCategoryCode,
    required this.amount,
  });
}

class SalaryChangeHistoryPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const SalaryChangeHistoryPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}
