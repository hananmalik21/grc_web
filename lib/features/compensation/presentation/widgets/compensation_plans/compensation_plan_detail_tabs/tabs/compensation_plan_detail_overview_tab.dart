import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/compensation_plan_detail_overview_cost_breakdown_card.dart'
    hide CostSlice;
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/compensation_plan_detail_overview_cost_breakdown_card.dart'
    as cost_card;
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/compensation_plan_detail_overview_distribution_card.dart'
    hide GradeDistributionPoint;
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/compensation_plan_detail_overview_distribution_card.dart'
    as dist_card;
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/compensation_plan_detail_overview_info_card.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/compensation_plan_detail_overview_trend_card.dart'
    hide MonthlyTrendPoint;
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/compensation_plan_detail_overview_trend_card.dart'
    as trend_card;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompensationPlanDetailOverviewTab extends StatelessWidget {
  final CompensationPlan plan;

  const CompensationPlanDetailOverviewTab({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSingleColumn = constraints.maxWidth < 900.w;
          final cardWidth = isSingleColumn ? constraints.maxWidth : (constraints.maxWidth - 16.w) / 2;

          return Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: [
              SizedBox(
                width: cardWidth,
                child: CompensationPlanDetailOverviewInfoCard(
                  data: CompensationPlanOverviewData(
                    generalInformation: [
                      OverviewField(label: 'Plan Type', value: plan.planTypeCode),
                      OverviewField(label: 'Currency', value: plan.currencyCode),
                      OverviewField(label: 'Business Unit', value: plan.displayBusinessUnit),
                      OverviewField(label: 'Status', value: plan.statusCode),
                      OverviewField(label: 'Created Date', value: plan.formattedCreationDate),
                      OverviewField(label: 'Last Modified', value: plan.formattedLastUpdateDate),
                    ],
                    owner: OwnerInfo(name: plan.displayOwnerName),
                  ),
                ),
              ),
              SizedBox(
                width: cardWidth,
                child: const CompensationPlanDetailOverviewCostBreakdownCard(
                  sections: [
                    cost_card.CostSlice(label: 'Base Salary', percentage: 57.6, color: AppColors.primary),
                    cost_card.CostSlice(label: 'Allowances', percentage: 23.1, color: AppColors.success),
                    cost_card.CostSlice(label: 'Benefits', percentage: 12.2, color: AppColors.warning),
                    cost_card.CostSlice(label: 'Variable Pay', percentage: 7.1, color: AppColors.error),
                  ],
                ),
              ),
              SizedBox(
                width: cardWidth,
                child: CompensationPlanDetailOverviewDistributionCard(
                  data:
                      plan.grades?.map((g) {
                        return dist_card.GradeDistributionPoint(
                          grade: g.grade?.number ?? '---',
                          employeeCount: 0,
                          averageSalary: g.grade?.step1Salary ?? 0,
                        );
                      }).toList() ??
                      const [],
                ),
              ),
              SizedBox(
                width: cardWidth,
                child: const CompensationPlanDetailOverviewTrendCard(
                  series: [
                    trend_card.MonthlyTrendPoint(month: 'Jan', actual: 0, projected: 0),
                    trend_card.MonthlyTrendPoint(month: 'Feb', actual: 0, projected: 0),
                    trend_card.MonthlyTrendPoint(month: 'Mar', actual: 0, projected: 0),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
