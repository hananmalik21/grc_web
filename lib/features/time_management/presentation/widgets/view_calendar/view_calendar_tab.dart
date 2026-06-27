import 'package:grc/features/time_management/presentation/providers/view_calendar_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewCalendarTab extends ConsumerWidget {
  const ViewCalendarTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveEnterpriseId = ref.watch(viewCalendarTabEnterpriseIdProvider);

    if (effectiveEnterpriseId == null) {
      return const Center(
        child: TimeManagementEmptyStateWidget(message: 'Please select an enterprise to view the calendar'),
      );
    }

    return const Center(child: Text('View Calendar Tab - Coming Soon'));
  }
}
