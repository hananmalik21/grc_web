import 'package:grc/features/time_management/presentation/providers/public_holidays_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_enterprise_id_provider.dart';
import 'package:grc/features/time_management/presentation/providers/view_calendar_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/common/time_management_tab_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeManagementTabWithEnterpriseSelector extends ConsumerWidget {
  const TimeManagementTabWithEnterpriseSelector({super.key, required this.tab, required this.child});

  final TimeManagementTab tab;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        timeManagementEnterpriseIdProvider.overrideWith(
          (ref) => switch (tab) {
            TimeManagementTab.shifts => ref.watch(shiftsTabEnterpriseIdProvider),
            TimeManagementTab.workPatterns => ref.watch(workPatternsTabEnterpriseIdProvider),
            TimeManagementTab.workSchedules => ref.watch(workSchedulesTabEnterpriseIdProvider),
            TimeManagementTab.scheduleAssignments => ref.watch(scheduleAssignmentsTabEnterpriseIdProvider),
            TimeManagementTab.viewCalendar => ref.watch(viewCalendarTabEnterpriseIdProvider),
            TimeManagementTab.publicHolidays => ref.watch(publicHolidaysTabEnterpriseIdProvider),
          },
        ),
      ],
      child: child,
    );
  }
}
