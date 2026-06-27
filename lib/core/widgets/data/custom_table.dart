import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Configuration for a table column
class TableColumn {
  final String key;
  final String label;
  final bool sortable;
  final double? width;
  final TextAlign alignment;
  final Widget Function(dynamic value, dynamic rowData)? cellBuilder;

  const TableColumn({
    required this.key,
    required this.label,
    this.sortable = false,
    this.width,
    this.alignment = TextAlign.start,
    this.cellBuilder,
  });
}

/// Generic reusable table widget with sorting, pagination, row selection
class CustomTable extends StatelessWidget {
  final List<TableColumn> columns;
  final List<Map<String, dynamic>> data;
  final String? sortColumn;
  final bool sortAscending;
  final ValueChanged<String>? onSort;
  final ValueChanged<Map<String, dynamic>>? onRowTap;
  final bool isLoading;
  final Widget? emptyStateWidget;
  final bool showHeader;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final Color? hoverRowBackgroundColor;
  final bool selectable;
  final Set<int>? selectedIndices;
  final ValueChanged<Set<int>>? onSelectionChanged;

  const CustomTable({
    super.key,
    required this.columns,
    required this.data,
    this.sortColumn,
    this.sortAscending = true,
    this.onSort,
    this.onRowTap,
    this.isLoading = false,
    this.emptyStateWidget,
    this.showHeader = true,
    this.headerBackgroundColor,
    this.rowBackgroundColor,
    this.hoverRowBackgroundColor,
    this.selectable = false,
    this.selectedIndices,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    if (isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.h),
          child: const CircularProgressIndicator(),
        ),
      );
    }

    // Debug: Log table data
    debugPrint(
      'CustomTable: Building with ${data.length} rows, ${columns.length} columns',
    );
    if (data.isNotEmpty) {
      debugPrint('CustomTable: First row keys: ${data.first.keys}');
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          if (showHeader) _buildHeader(context, isDark),
          if (data.isEmpty)
            Expanded(
              child:
                  emptyStateWidget ??
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.h),
                      child: Text(
                        'No data available',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
            )
          else
            Expanded(
              child: DualAxisScrollable(
                child: _buildTable(context, isDark),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color:
            headerBackgroundColor ??
            (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: columns.map((column) {
          return _buildHeaderCell(
            context,
            isDark,
            column,
            column.key == sortColumn,
            sortAscending,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    bool isDark,
    TableColumn column,
    bool isSorted,
    bool ascending,
  ) {
    final width = column.width ?? 150.w;
    final isSortable = column.sortable && onSort != null;

    return GestureDetector(
      onTap: isSortable
          ? () {
              if (isSorted) {
                // Toggle sort direction
                onSort!(column.key);
              } else {
                // Set new sort column
                onSort!(column.key);
              }
            }
          : null,
      child: Container(
        width: width,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                column.label,
                style: TextStyle(
                  fontSize: 13.8.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                  height: 20 / 13.8,
                  letterSpacing: 0,
                ),
                textAlign: column.alignment,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSortable) ...[
              SizedBox(width: 8.w),
              if (isSorted)
                Icon(
                  ascending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16.sp,
                  color: AppColors.primary,
                )
              else
                Icon(
                  Icons.unfold_more,
                  size: 16.sp,
                  color: isDark
                      ? AppColors.textPlaceholderDark
                      : AppColors.textPlaceholder,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context, bool isDark) {
    return Column(
      children: [
        ...data.asMap().entries.map<Widget>((entry) {
          final index = entry.key;
          final row = entry.value;
          final isSelected = selectedIndices?.contains(index) ?? false;

          if (index == 0) {
            debugPrint('CustomTable._buildTable: First row data: $row');
          }

          return _buildTableRow(context, isDark, row, index, isSelected);
        }),
      ],
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    bool isDark,
    Map<String, dynamic> row,
    int index,
    bool isSelected,
  ) {
    return MouseRegion(
      cursor: onRowTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onRowTap != null ? () => onRowTap!(row) : null,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.05))
                : (rowBackgroundColor ??
                      (isDark ? AppColors.cardBackgroundDark : Colors.white)),
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: columns.map((column) {
              return _buildTableCell(
                context,
                isDark,
                column,
                row[column.key],
                row,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(
    BuildContext context,
    bool isDark,
    TableColumn column,
    dynamic value,
    Map<String, dynamic> rowData,
  ) {
    final width = column.width ?? 150.w;

    Widget cellContent;
    if (column.cellBuilder != null) {
      cellContent = column.cellBuilder!(value, rowData);
    } else {
      cellContent = Text(
        value?.toString() ?? '',
        style: TextStyle(
          fontSize: 13.7.sp,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          height: 20 / 13.7,
          letterSpacing: 0,
        ),
        textAlign: column.alignment,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      child: cellContent,
    );
  }
}
