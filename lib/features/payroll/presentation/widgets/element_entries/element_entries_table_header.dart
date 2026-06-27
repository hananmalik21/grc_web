import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/features/payroll/application/element_entries/config/element_entries_table_config.dart';
import 'package:grc/features/payroll/application/element_entries/config/element_entries_table_types.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_table_width_provider.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElementEntriesTableHeader extends ConsumerWidget {
  const ElementEntriesTableHeader({required this.isDark, super.key});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(elementEntriesTableWidthsProvider);
    final uiState = ref.watch(elementEntriesUiProvider);
    final uiNotifier = ref.read(elementEntriesUiProvider.notifier);
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final allSelected = uiState.isAllSelected;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildSelectHeaderCell(
            allSelected: allSelected,
            enabled: uiState.entries.isNotEmpty,
            onChanged: uiState.entries.isEmpty ? null : uiNotifier.setSelectAll,
          ),
          ...state.columnOrder.asMap().entries.map((entry) {
            final column = entry.value;
            final isLastDataColumn = entry.key == state.columnOrder.length - 1;
            final isLastForBorder = isLastDataColumn && !ElementEntriesTableConfig.showActions;
            return _buildDraggableResizableHeaderCell(
              context,
              ref,
              column: column,
              label: _labelForColumn(column),
              width: state.widthFor(column),
              isLastDataColumn: isLastForBorder,
            );
          }),
          if (ElementEntriesTableConfig.showActions)
            _buildTextHeaderCell(context, 'ACTIONS', ElementEntriesTableConfig.actionsWidth.w, isLast: true),
        ],
      ),
    );
  }

  String _labelForColumn(ElementEntriesTableColumn column) {
    return switch (column) {
      ElementEntriesTableColumn.elementName => 'ELEMENT NAME',
      ElementEntriesTableColumn.primaryEntryValue => 'PRIMARY ENTRY VALUE',
      ElementEntriesTableColumn.valueName => 'VALUE NAME',
      ElementEntriesTableColumn.source => 'SOURCE',
      ElementEntriesTableColumn.employmentLevel => 'EMPLOYMENT LEVEL',
      ElementEntriesTableColumn.reason => 'REASON',
      ElementEntriesTableColumn.classification => 'CLASSIFICATION',
      ElementEntriesTableColumn.ldg => 'LDG',
      ElementEntriesTableColumn.empNumber => 'EMP. NUMBER',
      ElementEntriesTableColumn.status => 'STATUS',
    };
  }

  Widget _buildSelectHeaderCell({
    required bool allSelected,
    required bool enabled,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      width: ElementEntriesTableConfig.selectWidth.w,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 12.h),
      alignment: Alignment.center,
      child: DigifyCheckbox(
        value: allSelected,
        enabled: enabled,
        onChanged: onChanged == null ? null : (checked) => onChanged(checked ?? false),
      ),
    );
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
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
      ),
    );
  }

  Widget _buildDraggableResizableHeaderCell(
    BuildContext context,
    WidgetRef ref, {
    required ElementEntriesTableColumn column,
    required String label,
    required double width,
    required bool isLastDataColumn,
  }) {
    return DragTarget<ElementEntriesTableColumn>(
      onWillAcceptWithDetails: (details) => details.data != column,
      onAcceptWithDetails: (details) {
        ref.read(elementEntriesTableWidthsProvider.notifier).reorderColumn(details.data, column);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<ElementEntriesTableColumn>(
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
    required ElementEntriesTableColumn column,
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
            padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
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
                  ref.read(elementEntriesTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
