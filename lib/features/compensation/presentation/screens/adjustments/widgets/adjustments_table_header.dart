import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_table_width_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_table_selection_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_layout_config.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdjustmentsTableHeader extends ConsumerWidget {
  final bool isDark;
  final double widthMultiplier;
  final bool enableRowSelection;
  final List<AdjustmentRowData> selectableRows;

  const AdjustmentsTableHeader({
    super.key,
    required this.isDark,
    this.widthMultiplier = 1,
    this.enableRowSelection = false,
    this.selectableRows = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adjustmentsTableWidthsProvider);
    if (enableRowSelection) {
      ref.watch(bulkAdjustmentsTableSelectionProvider);
    }
    final selectionNotifier = ref.read(bulkAdjustmentsTableSelectionProvider.notifier);
    final allSelected = enableRowSelection && selectionNotifier.areAllSelected(selectableRows);

    return Container(
      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          ...state.columnOrder.asMap().entries.map((entry) {
            final column = entry.value;
            final isLastDataColumn =
                entry.key == state.columnOrder.length - 1 && !AdjustmentsTableLayoutConfig.showActions;
            final isEmployeeColumn = column == AdjustmentsTableColumn.employee;

            return _buildResizableHeaderCell(
              context,
              ref,
              label: _labelForColumn(column),
              width: state.widthFor(column) * widthMultiplier,
              column: column,
              isLast: isLastDataColumn,
              leading: enableRowSelection && isEmployeeColumn
                  ? DigifyCheckbox(
                      value: allSelected,
                      enabled: selectableRows.isNotEmpty,
                      onChanged: selectableRows.isEmpty ? null : (_) => selectionNotifier.toggleAll(selectableRows),
                    )
                  : null,
            );
          }),
          if (AdjustmentsTableLayoutConfig.showActions)
            _buildTextHeaderCell(
              context,
              'ACTIONS',
              AdjustmentsTableLayoutConfig.actionsWidth * widthMultiplier,
              isLast: true,
            ),
        ],
      ),
    );
  }

  String _labelForColumn(AdjustmentsTableColumn column) {
    return switch (column) {
      AdjustmentsTableColumn.employee => 'EMPLOYEE',
      AdjustmentsTableColumn.department => 'DEPARTMENT',
      AdjustmentsTableColumn.adjustmentType => 'ADJUSTMENT TYPE',
      AdjustmentsTableColumn.currentSalary => 'CURRENT SALARY',
      AdjustmentsTableColumn.adjustmentMethod => 'ADJUSTMENT METHOD',
      AdjustmentsTableColumn.adjustmentValue => 'ADJUSTMENT VALUE',
      AdjustmentsTableColumn.newSalary => 'NEW SALARY',
      AdjustmentsTableColumn.increase => 'INCREASE',
      AdjustmentsTableColumn.effectiveDate => 'EFFECTIVE DATE',
      AdjustmentsTableColumn.reason => 'REASON',
      AdjustmentsTableColumn.status => 'STATUS',
    };
  }

  Widget _buildTextHeaderCell(BuildContext context, String label, double width, {required bool isLast}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isLast ? Colors.transparent : AppColors.cardBorder, width: 1.w),
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 22.w, vertical: 14.h),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.labelSmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildResizableHeaderCell(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required double width,
    required AdjustmentsTableColumn column,
    required bool isLast,
    Widget? leading,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isLast ? Colors.transparent : AppColors.cardBorder, width: 1.w),
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 22.w, vertical: 14.h),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                if (leading != null) ...[leading, Gap(10.w)],
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 15.w,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  ref.read(adjustmentsTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
