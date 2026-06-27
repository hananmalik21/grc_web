import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance_summary/attendance_summary_list_mobile.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance_summary/component_attendance_summary_filters.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance_summary/component_attendance_summary_filters_mobile.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance_summary/component_attendance_summary_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceSummaryContent extends StatelessWidget {
  const AttendanceSummaryContent({
    required this.padding,
    required this.header,
    required this.enterpriseSelector,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;

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
            if (isMobile)
              ComponentAttendanceSummaryFiltersMobile(isDark: isDark)
            else
              ComponentAttendanceSummaryFilters(isDark: isDark),
            if (isMobile) const AttendanceSummaryListMobile() else const ComponentAttendanceSummaryTable(),
          ],
        ),
      ),
    );
  }
}
