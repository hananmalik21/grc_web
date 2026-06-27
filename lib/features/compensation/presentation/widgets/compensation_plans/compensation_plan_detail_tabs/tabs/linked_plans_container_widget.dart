import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'linked_component_card_widget.dart';

class LinkedPlansContainerWidget extends StatelessWidget {
  final List<PlanComponent> linkedComponents;

  const LinkedPlansContainerWidget({super.key, required this.linkedComponents});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Linked Plans',
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(4.h),
          Text(
            '${linkedComponents.length} linked component${linkedComponents.length == 1 ? '' : 's'}',
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
            ),
          ),
          Gap(10.h),
          if (linkedComponents.isEmpty)
            Text(
              'No linked components found.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 760.w
                    ? 1
                    : constraints.maxWidth < 1120.w
                    ? 2
                    : 3;
                final spacing = 10.w;
                final itemWidth = columns == 1
                    ? constraints.maxWidth
                    : (constraints.maxWidth - (spacing * (columns - 1))) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: 10.h,
                  children: [
                    for (final row in linkedComponents)
                      SizedBox(
                        width: itemWidth,
                        child: LinkedComponentCardWidget(row: row),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
