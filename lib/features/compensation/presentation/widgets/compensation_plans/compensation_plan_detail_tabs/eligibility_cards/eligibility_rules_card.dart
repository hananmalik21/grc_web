import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'eligibility_rule_section_card.dart';
import 'eligibility_shell_card.dart';
import 'eligibility_tab_data.dart';

class EligibilityRulesCard extends StatelessWidget {
  final List<EligibilityRuleItem> items;

  const EligibilityRulesCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return EligibilityShellCard(
      title: 'Eligibility Rules',
      subtitle: 'Criteria that determine which employees are eligible for this plan',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 760.w
              ? 1
              : constraints.maxWidth < 1120.w
              ? 2
              : 3;
          final spacing = 14.w;
          final itemWidth = columns == 1
              ? constraints.maxWidth
              : (constraints.maxWidth - (spacing * (columns - 1))) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: 16.h,
            children: [
              for (final item in items)
                SizedBox(
                  width: itemWidth,
                  child: EligibilityRuleSectionCard(item: item),
                ),
            ],
          );
        },
      ),
    );
  }
}
