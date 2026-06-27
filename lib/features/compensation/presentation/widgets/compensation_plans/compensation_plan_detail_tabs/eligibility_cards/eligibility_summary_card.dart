import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'eligibility_shell_card.dart';
import 'eligibility_summary_stat_card.dart';
import 'eligibility_tab_data.dart';

class EligibilitySummaryCard extends StatelessWidget {
  final List<EligibilitySummaryItem> items;

  const EligibilitySummaryCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return EligibilityShellCard(
      title: 'Eligibility Summary',
      subtitle: 'Overview of eligible employee population',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 700.w
              ? 1
              : constraints.maxWidth < 1080.w
              ? 2
              : 4;
          final spacing = 16.w;
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
                  child: EligibilitySummaryStatCard(item: item),
                ),
            ],
          );
        },
      ),
    );
  }
}
