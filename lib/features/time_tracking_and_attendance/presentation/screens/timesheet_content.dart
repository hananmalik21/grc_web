import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_search_and_filter.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_search_and_filter_mobile.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_stats.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_table.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_week_navigation.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/timesheet/timesheet_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimesheetContent extends ConsumerWidget {
  const TimesheetContent({required this.padding, required this.header, required this.enterpriseSelector, super.key});

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;
    final localizations = AppLocalizations.of(context)!;
    final state = ref.watch(timesheetNotifierProvider);
    final notifier = ref.read(timesheetNotifierProvider.notifier);

    final totalPages = state.totalItems == 0 ? 1 : (state.totalItems / state.pageSize).ceil();
    final paginationInfo = PaginationInfo(
      currentPage: state.currentPage,
      totalPages: totalPages,
      totalItems: state.totalItems,
      pageSize: state.pageSize,
      hasNext: state.currentPage < totalPages,
      hasPrevious: state.currentPage > 1,
    );

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.h,
          children: [
            header,
            enterpriseSelector,
            WeekNavigation(
              weekStartDate: state.weekStartDate,
              weekEndDate: state.weekEndDate,
              onPreviousWeek: notifier.goToPreviousWeek,
              onNextWeek: notifier.goToNextWeek,
              onCurrentWeek: notifier.goToCurrentWeek,
              onClearFilter: notifier.clearWeekFilter,
              onApplyFilter: notifier.applyWeekFilter,
              isDark: isDark,
              isCurrentWeek: state.isCurrentWeek,
              isWeekFilterEnabled: state.isWeekFilterEnabled,
            ),
            TimesheetStatsGrid(
              total: state.total,
              draft: state.draft,
              submitted: state.submitted,
              approved: state.approved,
              rejected: state.rejected,
              regularHours: state.regularHours,
              overtimeHours: state.overtimeHours,
              isDark: isDark,
              isLoading: state.isLoading,
            ),
            if (isMobile) const TimesheetSearchAndFilterMobile() else const TimesheetSearchAndFilter(),
            if (isMobile)
              TimesheetListMobile(paginationInfo: paginationInfo)
            else
              TimesheetTable(
                localizations: localizations,
                records: state.records,
                isDark: isDark,
                isLoading: state.isLoading,
                paginationInfo: paginationInfo,
                currentPage: state.currentPage,
                pageSize: state.pageSize,
                onPrevious: state.currentPage > 1 ? () => notifier.setPage(state.currentPage - 1) : null,
                onNext: state.currentPage < totalPages ? () => notifier.setPage(state.currentPage + 1) : null,
              ),
          ],
        ),
      ),
    );
  }
}
