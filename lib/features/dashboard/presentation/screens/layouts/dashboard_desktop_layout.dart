import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/dashboard/presentation/widgets/attendance_leaves_card.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_module_grid.dart';
import 'package:grc/features/dashboard/presentation/widgets/tasks_events_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final sideWidth = (constraints.maxWidth * 0.15).clamp(200.0, 250.0);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DashboardModuleGrid(buttons: buttons, onButtonTap: onButtonTap, isLoading: isLoadingModules),
            ),
            Gap(14.w),
            SizedBox(
              width: sideWidth,
              child: Column(
                children: [
                  TasksEventsCard(localizations: localizations),
                  Gap(14.h),
                  AttendanceLeavesCard(localizations: localizations),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
