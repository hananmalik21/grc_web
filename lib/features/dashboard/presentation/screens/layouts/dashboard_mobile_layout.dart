import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/dashboard/presentation/widgets/attendance_leaves_card.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_module_grid.dart';
import 'package:grc/features/dashboard/presentation/widgets/tasks_events_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DashboardMobileLayout extends StatelessWidget {
  const DashboardMobileLayout({
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
        DashboardModuleGrid(buttons: buttons, onButtonTap: onButtonTap, isLoading: isLoadingModules),
        Gap(14.h),
        TasksEventsCard(localizations: localizations),
        Gap(14.h),
        AttendanceLeavesCard(localizations: localizations),
      ],
    );
  }
}
