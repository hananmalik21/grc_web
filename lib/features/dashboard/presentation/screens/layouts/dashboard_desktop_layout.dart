import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_module_grid.dart';
import 'package:grc/features/dashboard/presentation/widgets/tasks_events_card.dart';
import 'package:grc/features/dashboard/presentation/widgets/attendance_leaves_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DashboardDesktopLayout extends StatelessWidget {
  const DashboardDesktopLayout({
    required this.buttons,
    required this.localizations,
    required this.onButtonTap,
    this.isLoadingModules = false,
    super.key,
  });

  final List<DashboardButton> buttons;
  final AppLocalizations localizations;
  final void Function(DashboardButton) onButtonTap;
  final bool isLoadingModules;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 12.h), // Space above header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MODULES',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1E293B),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                '${buttons.length}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF64748B) // slate-500
                      : const Color(0xFFCBD5E1), // slate-300
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h), // Space between header and cards
        DashboardModuleGrid(
          buttons: buttons,
          onButtonTap: onButtonTap,
          isLoading: isLoadingModules,
        ),
        SizedBox(height: 50.h),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Text(
            'Task Management & HR',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1E293B),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: TasksEventsCard(localizations: localizations),
            ),
            SizedBox(width: 16.w),
            Expanded(
              flex: 7,
              child: AttendanceLeavesCard(localizations: localizations),
            ),
          ],
        ),
        SizedBox(height: 32.h), // Bottom padding
      ],
    );
  }
}
