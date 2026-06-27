import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:grc/features/hiring/application/applications/providers/applications_table_width_provider.dart';
import 'applications_table_types.dart';

class ApplicationsTableHeader extends ConsumerWidget {
  const ApplicationsTableHeader({required this.isDark, super.key});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applicationsTableWidthsProvider);
    final headerBg = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final textColor = isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText;

    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: headerBg,
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          ...state.columnOrder.map((ApplicationsTableColumn column) {
            return _buildDraggableResizableHeaderCell(
              context,
              ref,
              column: column,
              label: _labelForColumn(column),
              width: state.widthFor(column),
              textColor: textColor,
            );
          }),
        ],
      ),
    );
  }

  String _labelForColumn(ApplicationsTableColumn column) {
    return switch (column) {
      ApplicationsTableColumn.applicationId => 'APPLICATION ID',
      ApplicationsTableColumn.candidate => 'CANDIDATE',
      ApplicationsTableColumn.requisition => 'REQUISITION',
      ApplicationsTableColumn.appliedDate => 'APPLIED DATE',
      ApplicationsTableColumn.currentStage => 'CURRENT STAGE',
      ApplicationsTableColumn.status => 'STATUS',
      ApplicationsTableColumn.source => 'SOURCE',
    };
  }

  Widget _buildDraggableResizableHeaderCell(
    BuildContext context,
    WidgetRef ref, {
    required ApplicationsTableColumn column,
    required String label,
    required double width,
    required Color textColor,
  }) {
    return DragTarget<ApplicationsTableColumn>(
      onWillAcceptWithDetails: (details) => details.data != column,
      onAcceptWithDetails: (details) {
        ref.read(applicationsTableWidthsProvider.notifier).reorderColumn(details.data, column);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<ApplicationsTableColumn>(
          data: column,
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(
              opacity: 0.9,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: width, height: 50.h),
                child: _buildResizableHeaderCell(
                  context,
                  ref,
                  label: label,
                  width: width,
                  column: column,
                  textColor: textColor,
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
              textColor: textColor,
            ),
          ),
          child: _buildResizableHeaderCell(
            context,
            ref,
            label: label,
            width: width,
            column: column,
            textColor: textColor,
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
    required ApplicationsTableColumn column,
    required Color textColor,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
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
              maxLines: 2,
              style: context.textTheme.labelSmall?.copyWith(color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 15.w,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (details) {
                ref.read(applicationsTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
