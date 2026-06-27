import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/security_manager/presentation/providers/data_classification/data_classification_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/data_classification/data_classification_level_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataClassificationLevelsSection extends StatelessWidget {
  final bool isDark;
  final List<DataClassificationLevel> levels;

  const DataClassificationLevelsSection({super.key, required this.isDark, required this.levels});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Classification Levels',
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap(16.h),
          if (levels.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  'No classifications match your search.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Column(
              spacing: 14.h,
              children: [for (final level in levels) DataClassificationLevelCard(level: level, isDark: isDark)],
            ),
        ],
      ),
    );
  }
}
