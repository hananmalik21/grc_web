import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/employee_compensation_table_width_provider.dart';
import 'employee_compensation_table_config.dart';
import 'employee_compensation_table_types.dart';

class EmployeeCompensationTableHeader extends ConsumerWidget {
  final bool isDark;

  const EmployeeCompensationTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeCompensationTableWidthsProvider);
    final dividerWidths = <double>[
      ...state.columnOrder.map(state.widthFor),
      EmployeeCompensationTableConfig.actionsWidth.w,
    ];

    return Container(
      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                for (var index = 0; index < dividerWidths.length; index++)
                  _DividerCell(width: dividerWidths[index], isLast: index == dividerWidths.length - 1),
              ],
            ),
          ),
          Row(
            children: [
              ...state.columnOrder.asMap().entries.map((entry) {
                final column = entry.value;
                return _buildDraggableResizableHeaderCell(
                  context,
                  ref,
                  column: column,
                  label: _labelForColumn(column),
                  width: state.widthFor(column),
                  isLast: false,
                );
              }),
              _HeaderCell(
                label: 'ACTIONS',
                width: EmployeeCompensationTableConfig.actionsWidth.w,
                isLast: true,
                alignment: Alignment.centerLeft,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableResizableHeaderCell(
    BuildContext context,
    WidgetRef ref, {
    required EmployeeCompensationTableColumn column,
    required String label,
    required double width,
    required bool isLast,
  }) {
    return DragTarget<EmployeeCompensationTableColumn>(
      onWillAcceptWithDetails: (details) => details.data != column,
      onAcceptWithDetails: (details) {
        ref.read(employeeCompensationTableWidthsProvider.notifier).reorderColumn(details.data, column);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<EmployeeCompensationTableColumn>(
          data: column,
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(
              opacity: 0.9,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: width, height: 44.h),
                child: _ResizableHeaderCell(
                  label: label,
                  width: width,
                  isLast: isLast,
                  alignment: Alignment.centerLeft,
                  onResize: (delta) {
                    ref.read(employeeCompensationTableWidthsProvider.notifier).updateWidth(column, delta);
                  },
                ),
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.35,
            child: _ResizableHeaderCell(
              label: label,
              width: width,
              isLast: isLast,
              alignment: Alignment.centerLeft,
              onResize: (delta) {
                ref.read(employeeCompensationTableWidthsProvider.notifier).updateWidth(column, delta);
              },
            ),
          ),
          child: _ResizableHeaderCell(
            label: label,
            width: width,
            isLast: isLast,
            alignment: Alignment.centerLeft,
            onResize: (delta) {
              ref.read(employeeCompensationTableWidthsProvider.notifier).updateWidth(column, delta);
            },
          ),
        );
      },
    );
  }

  static String _labelForColumn(EmployeeCompensationTableColumn column) {
    return switch (column) {
      EmployeeCompensationTableColumn.employee => 'EMPLOYEE',
      EmployeeCompensationTableColumn.department => 'DEPARTMENT',
      EmployeeCompensationTableColumn.region => 'REGION',
      EmployeeCompensationTableColumn.position => 'POSITION',
      EmployeeCompensationTableColumn.compensationPlan => 'COMPENSATION PLAN',
      EmployeeCompensationTableColumn.salaryStructure => 'SALARY STRUCTURE',
      EmployeeCompensationTableColumn.grade => 'GRADE',
      EmployeeCompensationTableColumn.baseSalary => 'BASE SALARY',
      EmployeeCompensationTableColumn.allowances => 'ALLOWANCES',
      EmployeeCompensationTableColumn.benefits => 'BENEFITS',
      EmployeeCompensationTableColumn.totalComp => 'TOTAL COMP.',
      EmployeeCompensationTableColumn.status => 'STATUS',
    };
  }
}

class _DividerCell extends StatelessWidget {
  final double width;
  final bool isLast;

  const _DividerCell({required this.width, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: AppColors.cardBorder, width: 1.w),
              ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final double width;
  final bool isLast;
  final Alignment alignment;

  const _HeaderCell({required this.label, required this.width, required this.isLast, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      alignment: alignment,
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
      ),
    );
  }
}

class _ResizableHeaderCell extends StatelessWidget {
  final String label;
  final double width;
  final bool isLast;
  final Alignment alignment;
  final ValueChanged<double> onResize;

  const _ResizableHeaderCell({
    required this.label,
    required this.width,
    required this.isLast,
    required this.alignment,
    required this.onResize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          _HeaderCell(label: label, width: width, isLast: isLast, alignment: alignment),
          if (!isLast)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 15.w,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) => onResize(details.delta.dx),
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
