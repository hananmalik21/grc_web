import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/components_table_width_provider.dart';
import 'components_table_config.dart';
import 'components_table_types.dart';

class ComponentsTableHeader extends ConsumerWidget {
  final bool isDark;

  const ComponentsTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(componentsTableWidthsProvider);
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          ...state.columnOrder.asMap().entries.map((entry) {
            final column = entry.value;
            final isLastDataColumn = entry.key == state.columnOrder.length - 1;
            return _buildDraggableResizableHeaderCell(
              context,
              ref,
              column: column,
              label: _labelForColumn(column),
              width: state.widthFor(column),
              isLastDataColumn: isLastDataColumn,
            );
          }),
          if (ComponentsTableConfig.showActions)
            _buildTextHeaderCell(context, 'ACTIONS', ComponentsTableConfig.actionsWidth.w, isLast: true),
        ],
      ),
    );
  }

  String _labelForColumn(ComponentsTableColumn column) {
    return switch (column) {
      ComponentsTableColumn.component => 'COMPONENT',
      ComponentsTableColumn.category => 'CATEGORY',
      ComponentsTableColumn.calculation => 'CALCULATION',
      ComponentsTableColumn.status => 'STATUS',
      ComponentsTableColumn.payroll => 'PAYROLL',
      ComponentsTableColumn.usedIn => 'USED IN',
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
    required ComponentsTableColumn column,
    required String label,
    required double width,
    required bool isLastDataColumn,
  }) {
    return DragTarget<ComponentsTableColumn>(
      onWillAcceptWithDetails: (details) => details.data != column,
      onAcceptWithDetails: (details) {
        ref.read(componentsTableWidthsProvider.notifier).reorderColumn(details.data, column);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<ComponentsTableColumn>(
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
    required ComponentsTableColumn column,
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
                  ref.read(componentsTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
