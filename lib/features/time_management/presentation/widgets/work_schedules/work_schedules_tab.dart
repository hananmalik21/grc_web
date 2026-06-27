import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/create_work_schedule_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_desktop_layout.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_mobile_layout.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_tablet_layout.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkSchedulesTab extends ConsumerStatefulWidget {
  const WorkSchedulesTab({super.key});

  @override
  ConsumerState<WorkSchedulesTab> createState() => _WorkSchedulesTabState();
}

class _WorkSchedulesTabState extends ConsumerState<WorkSchedulesTab> with WorkSchedulesPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(workSchedulesTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(workSchedulesNotifierProvider(enterpriseId).notifier).refresh();
        ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
      }
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(workSchedulesTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  void _onCreatePressed() {
    final enterpriseId = ref.read(workSchedulesTabEnterpriseIdProvider);
    if (enterpriseId == null) return;
    CreateWorkScheduleDialog.show(context, enterpriseId);
  }

  Future<void> _onDelete(WorkSchedule schedule) async {
    final enterpriseId = ref.read(workSchedulesTabEnterpriseIdProvider);
    if (enterpriseId == null) return;

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Delete Work Schedule',
      message: 'Are you sure you want to delete this work schedule? This action cannot be undone.',
      itemName: schedule.scheduleNameEn,
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(workSchedulesNotifierProvider(enterpriseId).notifier)
          .deleteWorkSchedule(schedule.workScheduleId, hard: true);

      if (!mounted) return;

      ToastService.success(context, 'Work schedule deleted successfully', title: 'Success');
    } on AppException catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.message, title: 'Error');
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to delete work schedule: ${e.toString()}', title: 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewWorkSchedule) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(workSchedulesTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return WorkSchedulesMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
        onDelete: _onDelete,
      );
    }
    if (layout.isTablet) {
      return WorkSchedulesTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
        onDelete: _onDelete,
      );
    }

    return WorkSchedulesDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreatePressed: _onCreatePressed,
      onDelete: _onDelete,
    );
  }
}
