import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/breadcrumb_nav_extra.dart';
import '../../../../core/services/responsive_service.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/digify_breadcrumb.dart';
import '../providers/time_management_tab_provider.dart';
import '../widgets/common/time_management_tab_config.dart';
import '../widgets/common/time_management_tab_with_enterprise_selector.dart';
import '../widgets/shifts/shifts_tab.dart';
import '../widgets/work_patterns/work_patterns_tab.dart';
import '../widgets/work_schedules/work_schedules_tab.dart';
import '../widgets/schedule_assignments/schedule_assignments_tab.dart';
import '../widgets/view_calendar/view_calendar_tab.dart';
import '../widgets/public_holidays/public_holidays_tab.dart';

class TimeManagementScreen extends ConsumerWidget {
  const TimeManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final currentTabIndex = ref.watch(timeManagementTabStateProvider.select((s) => s.currentTabIndex));
    final isMobile = ResponsiveHelper.isMobile(context);
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('timeManagement');
    final moduleSelectionLabel = navExtra?.returnLabel ?? 'Module Selection';
    final childLabel = navExtra?.leafLabel ?? _childLabelForTabIndex(currentTabIndex);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveHelper.getPagePadding(context),
            child: isMobile
                ? null
                : DigifyBreadcrumb(
                    items: [
                      DigifyBreadcrumbItem(label: 'Dashboard', onTap: () => context.go(AppRoutes.dashboard)),
                      const DigifyBreadcrumbItem(label: 'Time Management'),
                      DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                      DigifyBreadcrumbItem(label: childLabel),
                    ],
                  ),
          ),
          if (!isMobile) Gap(24.h),
          Expanded(child: _buildTabContent(context, currentTabIndex)),
        ],
      ),
    );
  }

  String _childLabelForTabIndex(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'Shifts';
      case 1:
        return 'Work Patterns';
      case 2:
        return 'Work Schedules';
      case 3:
        return 'Schedule Assignments';
      case 4:
        return 'View Calendar';
      case 5:
        return 'Public Holidays';
      default:
        return 'Shifts';
    }
  }

  Widget _buildTabContent(BuildContext context, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return TimeManagementTabWithEnterpriseSelector(tab: TimeManagementTab.shifts, child: const ShiftsTab());
      case 1:
        return TimeManagementTabWithEnterpriseSelector(
          tab: TimeManagementTab.workPatterns,
          child: const WorkPatternsTab(),
        );
      case 2:
        return TimeManagementTabWithEnterpriseSelector(
          tab: TimeManagementTab.workSchedules,
          child: const WorkSchedulesTab(),
        );
      case 3:
        return TimeManagementTabWithEnterpriseSelector(
          tab: TimeManagementTab.scheduleAssignments,
          child: const ScheduleAssignmentsTab(),
        );
      case 4:
        return TimeManagementTabWithEnterpriseSelector(
          tab: TimeManagementTab.viewCalendar,
          child: const ViewCalendarTab(),
        );
      case 5:
        return TimeManagementTabWithEnterpriseSelector(
          tab: TimeManagementTab.publicHolidays,
          child: const PublicHolidaysTab(),
        );
      default:
        return TimeManagementTabWithEnterpriseSelector(tab: TimeManagementTab.shifts, child: const ShiftsTab());
    }
  }
}
