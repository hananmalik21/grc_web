import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_levels/job_levels_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobLevelDetailMobileSheet extends StatelessWidget with JobLevelsPermissionMixin {
  const JobLevelDetailMobileSheet({super.key, required this.jobLevel, required this.onEdit});

  final JobLevel jobLevel;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobLevel.nameEn,
                  style: context.textTheme.titleSmall?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
                ),
                Gap(6.h),
                Row(
                  children: [
                    Text(
                      jobLevel.code,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    DigifyStatusCapsule(status: jobLevel.status),
                  ],
                ),
                Gap(16.h),
                const DigifyDivider.horizontal(),
                Gap(12.h),
                _InfoTile(label: localizations.description, value: jobLevel.description),
                Gap(10.h),
                _InfoTile(label: localizations.minimumGrade, value: jobLevel.gradeRange.split('-').first.trim()),
                Gap(10.h),
                _InfoTile(label: localizations.maximumGrade, value: jobLevel.gradeRange.split('-').last.trim()),
                Gap(10.h),
                _InfoTile(label: localizations.totalPositions, value: '${jobLevel.totalPositions}'),
              ],
            ),
          ),
        ),
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: Row(
            children: [
              AppButton.outline(label: localizations.close, onPressed: () => context.pop(), height: 46),
              if (canUpdateJobLevel) ...[
                Gap(10.w),
                Expanded(
                  child: AppButton.primary(
                    label: localizations.edit,
                    onPressed: () {
                      context.pop();
                      Future.microtask(onEdit);
                    },
                    height: 46,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final safeValue = value.trim().isEmpty ? '---' : value.trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(4.h),
          Text(safeValue, style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
