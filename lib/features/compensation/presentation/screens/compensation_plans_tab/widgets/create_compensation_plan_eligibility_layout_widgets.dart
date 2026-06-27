import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_compensation_plan_section_card.dart';

class EligibilitySectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const EligibilitySectionCard({super.key, required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return CreateCompensationPlanSectionCard(title: title, subtitle: subtitle, child: child);
  }
}

class EligibilityRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const EligibilityRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width < 768) {
      return Column(children: [left, Gap(20.h), right]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        Gap(28.w),
        Expanded(child: right),
      ],
    );
  }
}
