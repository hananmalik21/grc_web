import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'history_entry_data.dart';

class HistoryEntryItem extends StatelessWidget {
  const HistoryEntryItem({super.key, required this.data, required this.isDark, required this.isLast});

  final HistoryEntryData data;
  final bool isDark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobileLayout;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: isMobile ? 6.h : 8.h),
          child: DigifyStatusDot(color: AppColors.primary, size: isMobile ? 6.w : 8.w),
        ),
        Gap(isMobile ? 12.w : 16.w),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMobile) ...[
                Text(
                  data.action.toUpperCase(),
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(2.h),
                Text(
                  data.timestamp,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
                    fontSize: 11.sp,
                  ),
                ),
              ] else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.action.toUpperCase(),
                      style: context.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      data.timestamp,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
                      ),
                    ),
                  ],
                ),
              Gap(4.h),
              Text(
                data.description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  fontSize: isMobile ? 13.sp : 14.sp,
                ),
              ),
              Gap(4.h),
              Text(
                'By ${data.performedBy}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
                  fontSize: isMobile ? 11.sp : 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
