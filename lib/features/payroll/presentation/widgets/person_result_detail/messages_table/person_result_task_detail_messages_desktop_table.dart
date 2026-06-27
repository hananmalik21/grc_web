import 'dart:math' as math;

import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_message_row_data.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_column_widths.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_table_row.dart';
import 'package:flutter/material.dart';

class PersonResultTaskDetailMessagesDesktopTable extends StatelessWidget {
  const PersonResultTaskDetailMessagesDesktopTable({
    required this.rows,
    required this.expandedRowIds,
    required this.onToggleRow,
    super.key,
  });

  final List<PersonResultTaskDetailMessageRowData> rows;
  final Set<String> expandedRowIds;
  final ValueChanged<String> onToggleRow;

  @override
  Widget build(BuildContext context) {
    const baseWidths = PersonResultTaskDetailMessagesColumnWidths.base;

    return LayoutBuilder(
      builder: (context, constraints) {
        final baseContentWidth = baseWidths.totalWithPadding;
        final availableWidth = constraints.hasBoundedWidth && constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : baseContentWidth;
        final widthMultiplier = availableWidth > baseContentWidth
            ? (availableWidth - PersonResultTaskDetailMessagesColumnWidths.horizontalPadding) / baseWidths.total
            : 1.0;
        final columnWidths = PersonResultTaskDetailMessagesColumnWidths(multiplier: widthMultiplier);
        final tableWidth = math.max(baseContentWidth, availableWidth);

        return ScrollableSingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PersonResultTaskDetailMessagesTableColumnHeader(columnWidths: columnWidths),
                for (final row in rows)
                  PersonResultTaskDetailMessagesTableRow(
                    data: row,
                    columnWidths: columnWidths,
                    isExpanded: expandedRowIds.contains(row.id),
                    onToggleDetails: () => onToggleRow(row.id),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
