import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_message_row_data.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_column_widths.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_expanded_panel.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_table_cells.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonResultTaskDetailMessagesTableColumnHeader extends StatelessWidget {
  const PersonResultTaskDetailMessagesTableColumnHeader({required this.columnWidths, super.key});

  final PersonResultTaskDetailMessagesColumnWidths columnWidths;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final headerBg = isDark ? AppColors.grayBgDark.withValues(alpha: 0.35) : AppColors.tableHeaderBackground;
    final headerColor = isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText;
    final headerStyle = context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: headerColor);

    return Container(
      decoration: BoxDecoration(
        color: headerBg,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey)),
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          SizedBox(
            width: columnWidths.messageText,
            child: Text(loc.payrollPersonResultsTaskDetailMessagesMessageText, style: headerStyle),
          ),
          SizedBox(
            width: columnWidths.status,
            child: Text(loc.payrollPersonResultsTaskDetailStatus, style: headerStyle),
          ),
          SizedBox(
            width: columnWidths.taskName,
            child: Text(loc.payrollPersonResultsTaskName, style: headerStyle),
          ),
          SizedBox(
            width: columnWidths.details,
            child: Text(loc.payrollPersonResultsTaskDetailDetails, style: headerStyle),
          ),
        ],
      ),
    );
  }
}

class PersonResultTaskDetailMessagesTableRow extends StatelessWidget {
  const PersonResultTaskDetailMessagesTableRow({
    required this.data,
    required this.columnWidths,
    required this.isExpanded,
    required this.onToggleDetails,
    super.key,
  });

  final PersonResultTaskDetailMessageRowData data;
  final PersonResultTaskDetailMessagesColumnWidths columnWidths;
  final bool isExpanded;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBackgroundGrey;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.w, 18.h, 20.w, isExpanded ? 12.h : 18.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: columnWidths.messageText,
                  child: PersonResultTaskDetailMessageTextCell(
                    messageText: data.messageText,
                    severity: data.severity,
                    textColor: textColor,
                  ),
                ),
                SizedBox(
                  width: columnWidths.status,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: PersonResultTaskDetailMessageSeverityBadge(severity: data.severity),
                  ),
                ),
                SizedBox(
                  width: columnWidths.taskName,
                  child: Text(
                    data.taskName,
                    style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: textColor),
                  ),
                ),
                SizedBox(
                  width: columnWidths.details,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: PersonResultTaskDetailMessageDetailsButton(
                      isExpanded: isExpanded,
                      onPressed: onToggleDetails,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 18.h),
              child: PersonResultTaskDetailMessagesExpandedPanel(data: data),
            ),
          ],
        ],
      ),
    );
  }
}
