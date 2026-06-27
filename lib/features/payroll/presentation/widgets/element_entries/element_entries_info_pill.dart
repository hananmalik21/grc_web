import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ElementEntriesInfoPill extends StatelessWidget {
  const ElementEntriesInfoPill({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isDark ? AppColors.textTertiaryDark : AppColors.textPlaceholder;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final backgroundColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.dashboardBgGradientStart;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(999.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: context.textTheme.labelMedium?.copyWith(fontSize: 11.sp, color: labelColor),
          ),
          Gap(6.w),
          Text(
            value,
            style: context.textTheme.labelLarge?.copyWith(fontSize: 12.sp, color: valueColor),
          ),
        ],
      ),
    );
  }
}

class ElementEntriesInfoPills extends StatelessWidget {
  const ElementEntriesInfoPills({
    required this.personNumber,
    required this.payrollRelationship,
    required this.assignmentNumber,
    super.key,
  });

  final String personNumber;
  final String payrollRelationship;
  final String assignmentNumber;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        ElementEntriesInfoPill(label: loc.payrollElementEntriesPersonNo, value: personNumber),
        ElementEntriesInfoPill(label: loc.payrollElementEntriesPayrollRel, value: payrollRelationship),
        ElementEntriesInfoPill(label: loc.payrollElementEntriesAssignment, value: assignmentNumber),
      ],
    );
  }
}
