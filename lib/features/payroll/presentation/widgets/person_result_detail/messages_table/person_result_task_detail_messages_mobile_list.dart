import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_message_row_data.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_expanded_panel.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_table_cells.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailMessagesMobileCard extends StatelessWidget {
  const PersonResultTaskDetailMessagesMobileCard({
    required this.data,
    required this.isExpanded,
    required this.onToggleDetails,
    super.key,
  });

  final PersonResultTaskDetailMessageRowData data;
  final bool isExpanded;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      padding: EdgeInsetsDirectional.all(14.w),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tileBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PersonResultTaskDetailMessageTextCell(
            messageText: data.messageText,
            severity: data.severity,
            textColor: textColor,
          ),
          Gap(12.h),
          PersonResultTaskDetailMessageInfoLine(
            label: loc.payrollPersonResultsTaskDetailStatus,
            color: subtitleColor,
            child: PersonResultTaskDetailMessageSeverityBadge(severity: data.severity),
          ),
          Gap(8.h),
          PersonResultTaskDetailMessageInfoLine(
            label: loc.payrollPersonResultsTaskName,
            value: data.taskName,
            color: textColor,
          ),
          Gap(12.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: PersonResultTaskDetailMessageDetailsButton(isExpanded: isExpanded, onPressed: onToggleDetails),
          ),
          if (isExpanded) ...[Gap(12.h), PersonResultTaskDetailMessagesExpandedPanel(data: data)],
        ],
      ),
    );
  }
}

class PersonResultTaskDetailMessagesMobileList extends StatelessWidget {
  const PersonResultTaskDetailMessagesMobileList({
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.fromSTEB(12.w, 12.h, 12.w, 12.h),
      itemCount: rows.length,
      separatorBuilder: (_, _) => Gap(10.h),
      itemBuilder: (context, index) {
        final row = rows[index];
        return PersonResultTaskDetailMessagesMobileCard(
          data: row,
          isExpanded: expandedRowIds.contains(row.id),
          onToggleDetails: () => onToggleRow(row.id),
        );
      },
    );
  }
}
