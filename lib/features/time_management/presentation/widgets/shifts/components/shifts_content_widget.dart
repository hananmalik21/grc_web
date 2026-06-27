import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/empty_state_widget.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/components/shift_action_bar.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/components/shifts_grid.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/components/shifts_grid_skeleton.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/create_shift_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/shift_details_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/update_shift_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftsContentWidget extends ConsumerWidget {
  final int enterpriseId;
  final ValueChanged<ShiftOverview> onDelete;

  const ShiftsContentWidget({super.key, required this.enterpriseId, required this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftsState = ref.watch(shiftsNotifierProvider(enterpriseId));
    final notifier = ref.read(shiftsNotifierProvider(enterpriseId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShiftActionBar(enterpriseId: enterpriseId),
        Gap(24.h),
        _buildContent(context, shiftsState, notifier),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ShiftState shiftsState, ShiftsNotifier notifier) {
    if (shiftsState.isLoading) {
      return const ShiftsGridSkeleton();
    }

    if (shiftsState.hasError && shiftsState.items.isEmpty) {
      return DigifyErrorState(
        message: shiftsState.errorMessage ?? 'Failed to load shifts',
        onRetry: () => notifier.refresh(),
      );
    }

    if (shiftsState.items.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.schedule_outlined,
        title: 'No Shifts Found',
        message: 'There are no shifts available for this enterprise. Create a new shift to get started.',
        actionLabel: 'Create Shift',
        onAction: () => CreateShiftDialog.show(context, enterpriseId: enterpriseId),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShiftsGrid(
          shifts: shiftsState.items,
          onView: (shift) => ShiftDetailsDialog.show(context, shift),
          onEdit: (shift) => UpdateShiftDialog.show(context, shift, enterpriseId: enterpriseId),
          onCopy: (shift) {},
          onDelete: onDelete,
          deletingShiftId: shiftsState.deletingShiftId,
        ),
        if (shiftsState.totalPages > 0) ...[
          PaginationControls.fromPaginationInfo(
            paginationInfo: PaginationInfo(
              currentPage: shiftsState.currentPage,
              totalPages: shiftsState.totalPages,
              totalItems: shiftsState.totalItems,
              pageSize: shiftsState.pageSize,
              hasNext: shiftsState.hasNextPage,
              hasPrevious: shiftsState.hasPreviousPage,
            ),
            currentPage: shiftsState.currentPage,
            pageSize: shiftsState.pageSize,
            onPrevious: shiftsState.hasPreviousPage ? () => notifier.goToPage(shiftsState.currentPage - 1) : null,
            onNext: shiftsState.hasNextPage ? () => notifier.goToPage(shiftsState.currentPage + 1) : null,
            style: PaginationStyle.simple,
          ),
          Gap(24.h),
        ],
      ],
    );
  }
}
