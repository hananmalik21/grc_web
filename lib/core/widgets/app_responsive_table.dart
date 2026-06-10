import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Describes one table column for responsive visibility + sizing.
class AppTableColumnSpec {
  const AppTableColumnSpec({
    required this.minWidth,
    required this.dropPriority,
  });

  /// Minimum width in logical px (before ScreenUtil `.w`).
  final double minWidth;

  /// Higher values are hidden first when space is tight. Keep core columns at 0.
  final int dropPriority;
}

/// Picks visible column indices and builds [TableColumnWidth] map for a [Table].
class AppResponsiveTableLayout {
  AppResponsiveTableLayout({required this.columns});

  final List<AppTableColumnSpec> columns;

  /// Always keep at least this many columns (typically id, title/name, actions).
  static const int minVisibleColumns = 3;

  List<int> visibleIndicesForWidth(double availableWidth) {
    if (columns.isEmpty) return const [];

    final visible = List<int>.generate(columns.length, (i) => i);
    final minTotal = _totalWidth(visible);

    if (availableWidth >= minTotal.w) {
      return visible;
    }

    while (visible.length > minVisibleColumns) {
      final dropIndex = _indexToDrop(visible);
      if (dropIndex == null) break;

      visible.remove(dropIndex);
      if (_totalWidth(visible).w <= availableWidth) break;
    }

    return visible;
  }

  double minWidthForIndices(List<int> indices) {
    return indices.fold<double>(
      0,
      (sum, i) => sum + columns[i].minWidth.w,
    );
  }

  Map<int, TableColumnWidth> columnWidthsForIndices(List<int> indices) {
    return {
      for (int tableCol = 0; tableCol < indices.length; tableCol++)
        tableCol: FixedColumnWidth(columns[indices[tableCol]].minWidth.w),
    };
  }

  List<T> cellsForIndices<T>(List<T> allCells, List<int> indices) {
    return [for (final i in indices) allCells[i]];
  }

  double _totalWidth(List<int> indices) {
    return indices.fold<double>(
      0,
      (sum, i) => sum + columns[i].minWidth,
    );
  }

  int? _indexToDrop(List<int> visible) {
    int? candidate;
    var highestPriority = -1;

    for (final i in visible) {
      final priority = columns[i].dropPriority;
      if (priority > highestPriority) {
        highestPriority = priority;
        candidate = i;
      }
    }

    return candidate;
  }
}
