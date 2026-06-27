import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobPostingApplicationsSummary extends StatelessWidget {
  const JobPostingApplicationsSummary({super.key, required this.count, required this.isDark});

  final String count;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        const DigifyDivider(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.hiring.assignments.path,
                    width: 20.w,
                    height: 20.w,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                  Gap(8.w),
                  Text(
                    loc.hiringRequisitionJobPostingApplicationsReceivedLabel,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                count,
                style: context.textTheme.titleLarge?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  fontSize: 24.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
