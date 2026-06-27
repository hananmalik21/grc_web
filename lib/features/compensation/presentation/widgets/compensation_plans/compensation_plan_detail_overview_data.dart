import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/presentation/models/compensation_plan_table_row_data.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CompensationPlanDetailOverviewData {
  final List<OverviewField> generalInformation;
  final OwnerInfo owner;
  final List<CostSlice> costBreakdown;
  final List<GradeDistributionPoint> gradeDistribution;
  final List<MonthlyTrendPoint> monthlyTrend;

  const CompensationPlanDetailOverviewData({
    required this.generalInformation,
    required this.owner,
    required this.costBreakdown,
    required this.gradeDistribution,
    required this.monthlyTrend,
  });

  factory CompensationPlanDetailOverviewData.fromDomain(CompensationPlan plan) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return CompensationPlanDetailOverviewData(
      generalInformation: [
        OverviewField(label: 'Plan Type', value: plan.planTypeCode),
        OverviewField(label: 'Currency', value: plan.currencyCode),
        OverviewField(
          label: 'Business Unit',
          value: plan.businessUnits?.isNotEmpty == true ? plan.businessUnits!.first.orgUnit?.nameEn ?? '---' : '---',
        ),
        OverviewField(label: 'Status', value: plan.statusCode),
        OverviewField(
          label: 'Created Date',
          value: plan.creationDate != null ? dateFormat.format(plan.creationDate!) : '---',
        ),
        OverviewField(
          label: 'Last Modified',
          value: plan.lastUpdateDate != null ? dateFormat.format(plan.lastUpdateDate!) : '---',
        ),
      ],
      owner: OwnerInfo(initials: plan.owner?.displayInitials ?? '---', name: plan.owner?.displayName ?? '---'),
      costBreakdown: const [
        CostSlice(label: 'Base Salary', percentage: 57.6, color: AppColors.primary),
        CostSlice(label: 'Allowances', percentage: 23.1, color: AppColors.success),
        CostSlice(label: 'Benefits', percentage: 12.2, color: AppColors.warning),
        CostSlice(label: 'Variable Pay', percentage: 7.1, color: AppColors.error),
      ],
      gradeDistribution:
          plan.grades?.map((g) {
            return GradeDistributionPoint(
              grade: g.grade?.number ?? '---',
              employeeCount: 0,
              averageSalary: g.grade?.step1Salary ?? 0,
            );
          }).toList() ??
          const [],
      monthlyTrend: const [
        MonthlyTrendPoint(month: 'Jan', actual: 0, projected: 0),
        MonthlyTrendPoint(month: 'Feb', actual: 0, projected: 0),
        MonthlyTrendPoint(month: 'Mar', actual: 0, projected: 0),
      ],
    );
  }

  factory CompensationPlanDetailOverviewData.fromRow(CompensationPlanTableRowData row) {
    return CompensationPlanDetailOverviewData(
      generalInformation: [
        OverviewField(label: 'Plan Type', value: row.type),
        OverviewField(label: 'Currency', value: row.currency),
        const OverviewField(label: 'Business Unit', value: 'Corporate'),
        const OverviewField(label: 'Department', value: 'Executive Leadership'),
        const OverviewField(label: 'Created Date', value: '2025-11-15'),
        const OverviewField(label: 'Last Modified', value: '2026-02-10'),
      ],
      owner: const OwnerInfo(initials: 'SJ', name: 'Sarah Johnson'),
      costBreakdown: const [
        CostSlice(label: 'Base Salary', percentage: 57.6, color: Color(0xFF2563EB)),
        CostSlice(label: 'Allowances', percentage: 23.1, color: Color(0xFF10B981)),
        CostSlice(label: 'Benefits', percentage: 12.2, color: Color(0xFFF59E0B)),
        CostSlice(label: 'Variable Pay', percentage: 7.1, color: Color(0xFFEF4444)),
      ],
      gradeDistribution: const [
        GradeDistributionPoint(grade: 'M5', employeeCount: 8, averageSalary: 14667),
        GradeDistributionPoint(grade: 'M6', employeeCount: 12, averageSalary: 22000),
        GradeDistributionPoint(grade: 'M7', employeeCount: 10, averageSalary: 18333),
        GradeDistributionPoint(grade: 'M8', employeeCount: 8, averageSalary: 14667),
        GradeDistributionPoint(grade: 'M9', employeeCount: 5, averageSalary: 9167),
        GradeDistributionPoint(grade: 'M10+', employeeCount: 2, averageSalary: 3667),
      ],
      monthlyTrend: const [
        MonthlyTrendPoint(month: 'Jan', actual: 425000, projected: 425000),
        MonthlyTrendPoint(month: 'Feb', actual: 425000, projected: 425000),
        MonthlyTrendPoint(month: 'Mar', actual: 428000, projected: 428000),
        MonthlyTrendPoint(month: 'Apr', actual: 0, projected: 0),
        MonthlyTrendPoint(month: 'May', actual: 0, projected: 0),
        MonthlyTrendPoint(month: 'Jun', actual: 0, projected: 0),
      ],
    );
  }
}

class OverviewField {
  final String label;
  final String value;

  const OverviewField({required this.label, required this.value});
}

class OwnerInfo {
  final String initials;
  final String name;

  const OwnerInfo({required this.initials, required this.name});
}

class CostSlice {
  final String label;
  final double percentage;
  final Color color;

  const CostSlice({required this.label, required this.percentage, required this.color});
}

class GradeDistributionPoint {
  final String grade;
  final double employeeCount;
  final double averageSalary;

  const GradeDistributionPoint({required this.grade, required this.employeeCount, required this.averageSalary});
}

class MonthlyTrendPoint {
  final String month;
  final double actual;
  final double projected;

  const MonthlyTrendPoint({required this.month, required this.actual, required this.projected});
}
