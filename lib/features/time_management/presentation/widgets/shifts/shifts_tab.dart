import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/create_shift_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/shifts_desktop_layout.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/shifts_mobile_layout.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/shifts_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/shifts_tablet_layout.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShiftsTab extends ConsumerStatefulWidget {
  const ShiftsTab({super.key});

  @override
  ConsumerState<ShiftsTab> createState() => _ShiftsTabState();
}

class _ShiftsTabState extends ConsumerState<ShiftsTab> with ShiftsPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(shiftsTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(shiftsNotifierProvider(enterpriseId).notifier).refresh();
        ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
      }
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(shiftsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  void _onCreatePressed() {
    final enterpriseId = ref.read(shiftsTabEnterpriseIdProvider);
    if (enterpriseId == null) return;
    CreateShiftDialog.show(context, enterpriseId: enterpriseId);
  }

  Future<void> _onDelete(ShiftOverview shift) async {
    final enterpriseId = ref.read(shiftsTabEnterpriseIdProvider);
    if (enterpriseId == null) return;

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Delete Shift',
      message: 'Are you sure you want to delete this shift? This action cannot be undone.',
      itemName: shift.name,
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    if (confirmed != true) return;

    try {
      final success = await ref
          .read(shiftsNotifierProvider(enterpriseId).notifier)
          .deleteShift(shiftId: shift.id, hard: true);

      if (!mounted) return;

      if (success) {
        ToastService.success(context, 'Shift deleted successfully', title: 'Success');
      }
    } on AppException catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.message, title: 'Error');
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to delete shift: ${e.toString()}', title: 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewShift) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(shiftsTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return ShiftsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
        onDelete: _onDelete,
      );
    }
    if (layout.isTablet) {
      return ShiftsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
        onDelete: _onDelete,
      );
    }

    return ShiftsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreatePressed: _onCreatePressed,
      onDelete: _onDelete,
    );
  }
}
