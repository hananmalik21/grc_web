import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:flutter/material.dart';

class EligibilitySummaryItem {
  final String label;
  final String value;
  final String helperText;

  const EligibilitySummaryItem({required this.label, required this.value, required this.helperText});
}

class EligibilityRuleItem {
  final String title;
  final IconData icon;
  final List<String> values;

  const EligibilityRuleItem({required this.title, required this.icon, required this.values});
}

class EligibilityTabData {
  EligibilityTabData._();

  static List<EligibilitySummaryItem> getSummaryItems(CompensationPlan plan) {
    return [
      const EligibilitySummaryItem(label: 'Total Eligible', value: '---', helperText: 'Employees match criteria'),
      const EligibilitySummaryItem(label: 'Enrolled', value: '---', helperText: 'Enrollment rate'),
      const EligibilitySummaryItem(label: 'Pending', value: '---', helperText: 'Awaiting enrollment'),
      const EligibilitySummaryItem(label: 'Excluded', value: '---', helperText: 'Manually excluded'),
    ];
  }

  static List<EligibilityRuleItem> getRuleItems(CompensationPlan plan) {
    final items = <EligibilityRuleItem>[];

    if (plan.displayBusinessUnitList.isNotEmpty) {
      items.add(
        EligibilityRuleItem(
          title: 'Business Unit',
          icon: Icons.business_outlined,
          values: plan.displayBusinessUnitList,
        ),
      );
    }

    if (plan.displayGradeList.isNotEmpty) {
      items.add(EligibilityRuleItem(title: 'Grades', icon: Icons.adjust_outlined, values: plan.displayGradeList));
    }

    if (plan.displayLocationList.isNotEmpty) {
      items.add(
        EligibilityRuleItem(title: 'Location', icon: Icons.location_on_outlined, values: plan.displayLocationList),
      );
    }

    if (plan.displayEmploymentTypeList.isNotEmpty) {
      items.add(
        EligibilityRuleItem(
          title: 'Employment Type',
          icon: Icons.work_outline_rounded,
          values: plan.displayEmploymentTypeList,
        ),
      );
    }

    if (plan.displayJobFamilyList.isNotEmpty) {
      items.add(
        EligibilityRuleItem(title: 'Job Family', icon: Icons.group_outlined, values: plan.displayJobFamilyList),
      );
    }

    if (plan.displayPositionList.isNotEmpty) {
      items.add(EligibilityRuleItem(title: 'Positions', icon: Icons.badge_outlined, values: plan.displayPositionList));
    }

    if (plan.displaySalaryStructureList.isNotEmpty) {
      items.add(
        EligibilityRuleItem(
          title: 'Salary Structure',
          icon: Icons.table_chart_outlined,
          values: plan.displaySalaryStructureList,
        ),
      );
    }

    return items;
  }
}
