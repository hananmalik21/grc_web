import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PositionDetailsMobileSheet extends StatelessWidget {
  const PositionDetailsMobileSheet({super.key, required this.position, required this.onEdit});

  final Position position;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.titleEnglish,
                  style: context.textTheme.titleSmall?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
                ),
                Gap(6.h),
                Row(
                  children: [
                    Text(
                      position.code,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    DigifyStatusCapsule(status: position.status.isNotEmpty ? position.status : 'ACTIVE'),
                  ],
                ),
                if (position.titleArabic.isNotEmpty) ...[
                  Gap(8.h),
                  Text(
                    position.titleArabic,
                    textDirection: TextDirection.rtl,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
                Gap(16.h),
                const DigifyDivider.horizontal(),
                Gap(12.h),
                _InfoTile(label: localizations.department, value: position.department),
                Gap(10.h),
                _InfoTile(label: localizations.jobFamily, value: position.jobFamily),
                Gap(10.h),
                _InfoTile(label: localizations.jobLevel, value: position.level),
                Gap(10.h),
                _InfoTile(label: localizations.headcount, value: '${position.filled}/${position.headcount}'),
                Gap(10.h),
                _InfoTile(label: localizations.location, value: position.location),
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
