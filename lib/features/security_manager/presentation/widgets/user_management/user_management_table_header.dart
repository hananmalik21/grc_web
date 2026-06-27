import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/security_manager/data/config/user_management_table_config.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_management_table_width_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/user_management_table_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserManagementTableHeader extends ConsumerWidget {
  final bool isDark;
  final double widthMultiplier;

  const UserManagementTableHeader({super.key, required this.isDark, this.widthMultiplier = 1});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userManagementTableWidthsProvider);
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          ...state.columnOrder.asMap().entries.map((entry) {
            final column = entry.value;
            final isLastDataColumn =
                entry.key == state.columnOrder.length - 1 && !UserManagementTableConfig.showActions;
            return _buildDraggableResizableHeaderCell(
              context,
              ref,
              column: column,
              label: _labelForColumn(column),
              width: state.widthFor(column) * widthMultiplier,
              isLastDataColumn: isLastDataColumn,
            );
          }),
          if (UserManagementTableConfig.showActions)
            _buildTextHeaderCell(
              context,
              'Actions',
              UserManagementTableConfig.actionsWidth * widthMultiplier,
              isLast: true,
            ),
        ],
      ),
    );
  }

  String _labelForColumn(UserManagementTableColumn column) {
    return switch (column) {
      UserManagementTableColumn.user => 'User Details',
      UserManagementTableColumn.department => 'Department',
      UserManagementTableColumn.roles => 'Assigned Roles',
      UserManagementTableColumn.status => 'Status',
      UserManagementTableColumn.security => 'Security',
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
    required UserManagementTableColumn column,
    required String label,
    required double width,
    required bool isLastDataColumn,
  }) {
    return DragTarget<UserManagementTableColumn>(
      onWillAcceptWithDetails: (details) => details.data != column,
      onAcceptWithDetails: (details) {
        ref.read(userManagementTableWidthsProvider.notifier).reorderColumn(details.data, column);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<UserManagementTableColumn>(
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
    required UserManagementTableColumn column,
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
                  ref.read(userManagementTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
