import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/responsive_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/breadcrumb_nav_extra.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/digify_breadcrumb.dart';
import '../providers/time_tracking_and_attendance_tab_state_provider.dart';
import 'attendance_screen.dart';
import 'attendance_summary_screen.dart';
import 'employee_locations_screen.dart';
import 'geo_locations_screen.dart';
import 'overtime_configuration_screen.dart';
import 'overtime_screen.dart';
import 'timesheet_screen.dart';

class TimeTrackingAndAttendanceScreen extends ConsumerWidget {
  const TimeTrackingAndAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final currentTabIndex = ref.watch(timeTrackingAndAttendanceTabStateProvider.select((s) => s.currentTabIndex));
    final isMobile = ResponsiveHelper.isMobile(context);
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('timeTrackingAttendance');
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
                      const DigifyBreadcrumbItem(label: 'Time Tracking & Attendance'),
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
        return 'Attendance';
      case 1:
        return 'Timesheet';
      case 2:
        return 'Overtime';
      case 3:
        return 'Overtime Configuration';
      case 4:
        return 'Attendance Summary';
      case 5:
        return 'Geo Locations';
      case 6:
        return 'Employee Locations';
      default:
        return 'Attendance';
    }
  }

  Widget _buildTabContent(BuildContext context, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const AttendanceScreen();
      case 1:
        return const TimesheetScreen();
      case 2:
        return const OvertimeScreen();
      case 3:
        return const OvertimeConfigurationScreen();
      case 4:
        return const AttendanceSummaryScreen();
      case 5:
        return const GeoLocationsScreen();
      case 6:
        return const EmployeeLocationsScreen();
      default:
        return const SizedBox();
    }
  }
}
