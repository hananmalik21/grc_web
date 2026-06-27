import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/compensation_plans/compensation_plans_table_width_provider.dart';
import 'compensation_plans_table_config.dart';
import 'compensation_plans_table_types.dart';

class CompensationPlansTableHeader extends ConsumerWidget {
  final bool isDark;
  final double widthMultiplier;

  const CompensationPlansTableHeader({super.key, required this.isDark, this.widthMultiplier = 1});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(compensationPlansTableWidthsProvider);
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          ...state.columnOrder.asMap().entries.map((entry) {
            final column = entry.value;
            final isLastDataColumn =
                entry.key == state.columnOrder.length - 1 && !CompensationPlansTableConfig.showActions;
            return _buildDraggableResizableHeaderCell(
              context,
              ref,
              column: column,
              label: _labelForColumn(column),
              width: state.widthFor(column) * widthMultiplier,
              isLastDataColumn: isLastDataColumn,
            );
          }),
          if (CompensationPlansTableConfig.showActions)
            _buildTextHeaderCell(
              context,
              'Actions',
              CompensationPlansTableConfig.actionsWidth * widthMultiplier,
              isLast: true,
            ),
        ],
      ),
    );
  }

  String _labelForColumn(CompensationPlansTableColumn column) {
    return switch (column) {
      CompensationPlansTableColumn.planName => 'Plan Name',
      CompensationPlansTableColumn.planCode => 'Plan Code',
      CompensationPlansTableColumn.planType => 'Plan Type',
      CompensationPlansTableColumn.status => 'Status',
      CompensationPlansTableColumn.currency => 'Currency',
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
        style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
      ),
    );
  }

  Widget _buildDraggableResizableHeaderCell(
    BuildContext context,
    WidgetRef ref, {
    required CompensationPlansTableColumn column,
    required String label,
    required double width,
    required bool isLastDataColumn,
  }) {
    return DragTarget<CompensationPlansTableColumn>(
      onWillAcceptWithDetails: (details) => details.data != column,
      onAcceptWithDetails: (details) {
        ref.read(compensationPlansTableWidthsProvider.notifier).reorderColumn(details.data, column);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<CompensationPlansTableColumn>(
          data: column,
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(
              opacity: 0.9,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: width, height: 48.h),
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
    required CompensationPlansTableColumn column,
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
            padding: EdgeInsetsDirectional.symmetric(horizontal: 22.w, vertical: 14.h),
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
                  ref.read(compensationPlansTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
