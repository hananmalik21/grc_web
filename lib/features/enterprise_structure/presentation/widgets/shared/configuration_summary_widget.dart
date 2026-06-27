import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ConfigurationSummaryWidget extends StatelessWidget {
  final int totalLevels;
  final int activeLevels;
  final int hierarchyDepth;
  final String topLevel;

  const ConfigurationSummaryWidget({
    super.key,
    required this.totalLevels,
    required this.activeLevels,
    required this.hierarchyDepth,
    required this.topLevel,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final textTheme = context.textTheme;

    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.infoBg,
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.infoBorder, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.configurationSummary,
            style: textTheme.titleSmall?.copyWith(fontSize: 16.sp, color: textColor),
          ),
          Gap(8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.h,
                  children: [
                    _SummaryRow(
                      label: '${localizations.totalLevels}: ',
                      value: '$totalLevels',
                      textColor: textColor,
                      textTheme: textTheme,
                    ),
                    _SummaryRow(
                      label: '${localizations.hierarchyDepth}: ',
                      value: '$hierarchyDepth levels',
                      textColor: textColor,
                      textTheme: textTheme,
                    ),
                  ],
                ),
              ),
              Gap(24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.h,
                  children: [
                    _SummaryRow(
                      label: '${localizations.activeLevels}: ',
                      value: '$activeLevels',
                      textColor: textColor,
                      textTheme: textTheme,
                    ),
                    _SummaryRow(
                      label: '${localizations.topLevel}: ',
                      value: topLevel,
                      textColor: textColor,
                      textTheme: textTheme,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final TextTheme textTheme;

  const _SummaryRow({required this.label, required this.value, required this.textColor, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        style: textTheme.bodyMedium?.copyWith(color: textColor),
        children: [
          TextSpan(
            text: value,
            style: textTheme.titleSmall?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
