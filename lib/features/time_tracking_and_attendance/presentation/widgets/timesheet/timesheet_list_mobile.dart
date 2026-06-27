import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/timesheet_permission_mixin.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/timesheet/timesheet_list_mobile_logic_mixin.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/timesheet/timesheet_skeleton_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimesheetListMobile extends ConsumerStatefulWidget {
  const TimesheetListMobile({required this.paginationInfo, super.key});

  final PaginationInfo paginationInfo;

  @override
  ConsumerState<TimesheetListMobile> createState() => _TimesheetListMobileState();
}

class _TimesheetListMobileState extends ConsumerState<TimesheetListMobile>
    with TimesheetListMobileLogicMixin, TimesheetPermissionMixin {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(timesheetNotifierProvider);
    final records = state.records;
    final isLoading = state.isLoading;
    final info = widget.paginationInfo;

    if (!isLoading && records.isEmpty) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
        icon: Icon(
          Icons.inbox_outlined,
          size: 32.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
        title: 'No Timesheets Found',
        subtitle: 'No timesheets match your current filters.',
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
          TimesheetSkeletonList(
            records: records,
            isLoading: isLoading,
            approvingGuid: state.approvingTimesheetGuid,
            rejectingGuid: state.rejectingTimesheetGuid,
            isDark: isDark,
            onEdit: canUpdateTimesheet ? (t) => editTimesheet(context, t) : null,
            onView: canViewTimesheet ? (t) => viewTimesheetDetail(context, t) : null,
            onApprove: canApproveTimesheet ? (t) => approveTimesheet(context, t) : null,
            onReject: canApproveTimesheet ? (t) => rejectTimesheet(context, t) : null,
          ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: state.currentPage,
            totalPages: info.totalPages,
            hasPrevious: info.hasPrevious,
            hasNext: info.hasNext,
            onPrevious: info.hasPrevious && !isLoading ? () => goToPage(state.currentPage - 1) : null,
            onNext: info.hasNext && !isLoading ? () => goToPage(state.currentPage + 1) : null,
          ),
        ],
      ),
    );
  }
}
