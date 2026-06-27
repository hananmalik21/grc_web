import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_dialog_styles.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveDetailsLaborLawSection extends StatelessWidget {
  const LeaveDetailsLaborLawSection({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: leaveDetailsCardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.arrowRightIcon.path,
                width: 18,
                height: 18,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
              Gap(8.w),
              Expanded(
                child: Text(
                  'Kuwait Labor Law No. 6/2010 — Leave Entitlements',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: _LawInfoItem(
                  title: 'Annual Leave',
                  description: '30 days per year (2.5 days/month)',
                  isDark: isDark,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _LawInfoItem(
                  title: 'Sick Leave',
                  description: '15 days full + 10 half + 10 unpaid',
                  isDark: isDark,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _LawInfoItem(
                  title: 'Accrual Method',
                  description: 'Monthly accrual after probation',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LawInfoItem extends StatelessWidget {
  const _LawInfoItem({required this.title, required this.description, required this.isDark});

  final String title;
  final String description;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(4.h),
        Text(
          description,
          style: context.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
