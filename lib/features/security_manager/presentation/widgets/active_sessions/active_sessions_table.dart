import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/security_manager/domain/models/active_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'active_sessions_table_header.dart';
import 'active_sessions_table_row.dart';

class ActiveSessionsTable extends StatelessWidget {
  final List<ActiveSession> sessions;
  final bool isDark;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const ActiveSessionsTable({
    super.key,
    required this.sessions,
    required this.isDark,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inbox_outlined,
                  size: 64.sp,
                  color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                ),
              ),
              Gap(24.h),
              Text(
                'No Active Sessions Found',
                style: context.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48.w),
                child: Text(
                  'No active sessions match your current filters. Try adjusting your search or status filter.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textMuted : AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActiveSessionsTableHeader(isDark: isDark),
                  ...sessions.map((s) => ActiveSessionsTableRow(session: s, isDark: isDark)),
                ],
              ),
            ),
          ),
          PaginationControls(
            currentPage: currentPage,
            totalPages: totalItems == 0 ? 1 : (totalItems / pageSize).ceil(),
            totalItems: totalItems,
            pageSize: pageSize,
            hasNext: (currentPage * pageSize) < totalItems,
            hasPrevious: currentPage > 1,
            onPrevious: onPrevious,
            onNext: onNext,
            isLoading: false,
            style: PaginationStyle.simple,
          ),
        ],
      ),
    );
  }
}
