import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_config.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_types.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_detail_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayrollProcessResultsTableHeader extends ConsumerWidget {
  const PayrollProcessResultsTableHeader({required this.isDark, super.key});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(personResultDetailTableWidthsProvider);
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          ...state.columnOrder.asMap().entries.map((entry) {
            final column = entry.value;
            final isLastDataColumn =
                entry.key == state.columnOrder.length - 1 && !PersonResultDetailTableConfig.showActions;
            return _buildDraggableResizableHeaderCell(
              context,
              ref,
              column: column,
              label: _labelForColumn(loc, column),
              width: state.widthFor(column),
              isLastDataColumn: isLastDataColumn,
            );
          }),
          if (PersonResultDetailTableConfig.showActions)
            _buildTextHeaderCell(context, loc.actions, PersonResultDetailTableConfig.actionsWidth.w, isLast: true),
        ],
      ),
    );
  }

  String _labelForColumn(AppLocalizations loc, PersonResultDetailTableColumn column) {
    return switch (column) {
      PersonResultDetailTableColumn.taskName => loc.payrollPersonResultsTaskName,
      PersonResultDetailTableColumn.status => loc.status,
      PersonResultDetailTableColumn.flowName => loc.payrollPersonResultsFlowName,
      PersonResultDetailTableColumn.processDate => loc.payrollPersonResultsProcessDate,
      PersonResultDetailTableColumn.payroll => loc.payrollPersonResultsPayrollColumn,
      PersonResultDetailTableColumn.payrollPeriod => loc.payrollPersonResultsPayrollPeriod,
      PersonResultDetailTableColumn.amount => loc.amount,
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
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 14.h),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.tableHeaderText),
      ),
    );
  }

  Widget _buildDraggableResizableHeaderCell(
    BuildContext context,
    WidgetRef ref, {
    required PersonResultDetailTableColumn column,
    required String label,
    required double width,
    required bool isLastDataColumn,
  }) {
    return DragTarget<PersonResultDetailTableColumn>(
      onWillAcceptWithDetails: (details) => details.data != column,
      onAcceptWithDetails: (details) {
        ref.read(personResultDetailTableWidthsProvider.notifier).reorderColumn(details.data, column);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<PersonResultDetailTableColumn>(
          data: column,
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(
              opacity: 0.9,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: width, height: 44.h),
                child: _buildResizableHeaderCell(
                  context,
                  ref,
                  label: label,
                  width: width,
                  column: column,
                  isLast: isLastDataColumn,
                ),
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.35,
            child: _buildResizableHeaderCell(
              context,
              ref,
              label: label,
              width: width,
              column: column,
              isLast: isLastDataColumn,
            ),
          ),
          child: _buildResizableHeaderCell(
            context,
            ref,
            label: label,
            width: width,
            column: column,
            isLast: isLastDataColumn,
          ),
        );
      },
    );
  }

  Widget _buildResizableHeaderCell(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required double width,
    required PersonResultDetailTableColumn column,
    required bool isLast,
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
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 14.h),
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.tableHeaderText,
              ),
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
                  ref.read(personResultDetailTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
