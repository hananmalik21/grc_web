import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_preview_employee.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_schedule_entry.dart';
import 'package:grc/features/leave_management/presentation/widgets/common/leave_management_stat_card.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_processing/forfeit_preview_table.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PreviewReviewContent extends StatelessWidget {
  final List<ForfeitPreviewEmployee> employees;
  final bool isDark;
  final ForfeitScheduleEntry? selectedScheduleEntry;

  const PreviewReviewContent({super.key, required this.employees, required this.isDark, this.selectedScheduleEntry});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    // Calculate stats
    final employeesAffected = employees.length;
    final totalDaysToForfeit = employees.fold<double>(
      0.0,
      (sum, employee) => sum + (employee.forfeitDays < 0 ? employee.forfeitDays.abs() : 0),
    );
    final processingPeriod = selectedScheduleEntry?.monthYear ?? 'N/A';

    final statCards = [
      LeaveManagementStatCard(
        label: 'Employees Affected',
        value: employeesAffected.toString(),
        iconPath: Assets.icons.usersIcon.path,
        isDark: isDark,
      ),
      LeaveManagementStatCard(
        label: 'Total Days to Forfeit',
        value: totalDaysToForfeit.toStringAsFixed(totalDaysToForfeit == totalDaysToForfeit.toInt() ? 0 : 1),
        iconPath: Assets.icons.leaveManagement.downfall.path,
        isDark: isDark,
      ),
      LeaveManagementStatCard(
        label: 'Processing Period',
        value: processingPeriod,
        iconPath: Assets.icons.clockIcon.path,
        isDark: isDark,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile)
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: statCards.map((card) {
              return SizedBox(width: (context.deviceWidth - 48.w - 12.w) / 2, child: card);
            }).toList(),
          )
        else if (isTablet)
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: statCards.map((card) {
              return SizedBox(width: (context.deviceWidth - 48.w - 12.w) / 2, child: card);
            }).toList(),
          )
        else
          Row(
            children: [
              for (int i = 0; i < statCards.length; i++) ...[
                Expanded(child: statCards[i]),
                if (i < statCards.length - 1) Gap(21.w),
              ],
            ],
          ),
        Gap(21.h),
        ForfeitPreviewTable(employees: employees, localizations: localizations, isDark: isDark),
      ],
    );
  }
}
