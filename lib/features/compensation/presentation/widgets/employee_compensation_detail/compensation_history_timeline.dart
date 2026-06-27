import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_section_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationHistoryTimeline extends StatelessWidget {
  const CompensationHistoryTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return CompensationSectionCard(
      title: 'Compensation History',
      child: Column(
        children: [
          _buildHistoryItem(
            context,
            title: 'Annual Salary Increase',
            subtitle: 'Base Salary',
            oldValue: '\$8,000',
            newValue: '\$8,500',
            user: 'David Wilson - HR Director',
            date: '2026-01-15',
            isFirst: true,
            isLast: false,
          ),
          _buildHistoryItem(
            context,
            title: 'Allowance Allocation',
            subtitle: 'Housing Allowance added',
            newValue: '\$2,000',
            user: 'Sarah Thompson - Compensation Manager',
            date: '2025-08-01',
            isFirst: false,
            isLast: false,
          ),
          _buildHistoryItem(
            context,
            title: 'Structure Change',
            subtitle: 'Moved to Executive Salary Structure',
            user: 'Michael Chen - HR Manager',
            date: '2025-03-01',
            isFirst: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    String? oldValue,
    String? newValue,
    required String user,
    required String date,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isDark = context.isDark;
    final connectorColor = isDark ? AppColors.borderGreyDark : AppColors.cardBorder;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
      child: Stack(
        children: [
          if (!isLast)
            Positioned(
              left: (24.w - 2.w) / 2,
              top: 28.h,
              bottom: 0,
              child: Container(width: 2.w, color: connectorColor),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24.w,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: DigifyAsset(
                    assetPath: Assets.icons.auditTrailIconDepartment.path,
                    color: AppColors.primary,
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: context.textTheme.titleSmall?.copyWith(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Gap(16.w),
                          Text(
                            date,
                            style: context.textTheme.labelSmall?.copyWith(
                              fontSize: 12.sp,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
                            ),
                          ),
                        ],
                      ),
                      Gap(4.h),
                      Text(
                        subtitle,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                      if (newValue != null) ...[
                        Gap(4.h),
                        Row(
                          children: [
                            if (oldValue != null) ...[
                              Text(
                                oldValue,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Gap(8.w),
                              Icon(Icons.arrow_forward, size: 14.w, color: AppColors.textSecondary),
                              Gap(8.w),
                            ],
                            Text(
                              newValue,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                      Gap(8.h),
                      _buildActorRow(context, user),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActorRow(BuildContext context, String userName) {
    final isDark = context.isDark;
    final bg = isDark ? AppColors.infoBgDark.withValues(alpha: 0.24) : AppColors.dutyRoleGradientStart;

    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        children: [
          AppAvatar(size: 24.w, fallbackInitial: userName, backgroundColor: bg),
          Gap(8.w),
          Expanded(
            child: Text(
              userName,
              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 12.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
