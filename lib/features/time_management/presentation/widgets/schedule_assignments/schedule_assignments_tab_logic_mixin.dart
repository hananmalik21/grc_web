import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/create_schedule_assignment_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin ScheduleAssignmentsTabLogicMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  int get enterpriseId => ref.read(scheduleAssignmentsTabEnterpriseIdProvider)!;

  Future<void> reloadAssignments(int enterpriseId) async {
    final notifier = ref.read(scheduleAssignmentsNotifierProvider(enterpriseId).notifier);
    notifier.setEnterpriseId(enterpriseId);
    notifier.reset();
    await notifier.refresh();
  }

  Future<void> reloadAssignmentsAndStats(int enterpriseId) async {
    await reloadAssignments(enterpriseId);
    await ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
  }

  void onEnterpriseChanged(int? enterpriseId) {
    ref.read(scheduleAssignmentsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    reloadAssignmentsAndStats(enterpriseId!);
  }

  void onCreatePressed(BuildContext context) {
    CreateScheduleAssignmentDialog.show(context, enterpriseId);
  }

  Future<void> onDelete(BuildContext context, ScheduleAssignment assignment) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Delete Schedule Assignment',
      message: 'Are you sure you want to delete this schedule assignment?',
      itemName: '${assignment.assignedToName} - ${assignment.workSchedule?.scheduleNameEn ?? 'N/A'}',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(scheduleAssignmentsNotifierProvider(enterpriseId).notifier)
          .deleteScheduleAssignment(assignment.scheduleAssignmentId, hard: true);

      if (!context.mounted) return;

      await ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
      if (!context.mounted) return;
      ToastService.success(context, 'Schedule assignment deleted successfully', title: 'Success');
    } on AppException catch (e) {
      if (!context.mounted) return;
      ToastService.error(context, e.message, title: 'Error');
    } catch (e) {
      if (!context.mounted) return;
      ToastService.error(context, 'Failed to delete schedule assignment: ${e.toString()}', title: 'Error');
    }
  }
}
