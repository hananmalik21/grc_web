import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/eligibility_cards/eligibility_rules_card.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/eligibility_cards/eligibility_summary_card.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/eligibility_cards/eligibility_tab_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationPlanDetailEligibilityTab extends StatelessWidget {
  final CompensationPlan plan;

  const CompensationPlanDetailEligibilityTab({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EligibilitySummaryCard(items: EligibilityTabData.getSummaryItems(plan)),
        Gap(16.h),
        EligibilityRulesCard(items: EligibilityTabData.getRuleItems(plan)),
      ],
    );
  }
}
