import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_config.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_types.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_detail_table_width_provider.dart';
import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:grc/features/payroll/domain/models/person_result_employee.dart';
import 'package:grc/features/payroll/presentation/models/person_result_task_detail_args.dart';
import 'package:grc/features/payroll/presentation/screens/person_results/person_result_task_detail_page.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PayrollProcessResultsTableRow extends ConsumerWidget {
  const PayrollProcessResultsTableRow({required this.employee, required this.task, required this.isDark, super.key});

  final PersonResultEmployee employee;
  final PayrollProcessResultTask task;
  final bool isDark;

  void _openTaskDetail(BuildContext context) {
    context.pushNamed(
      PersonResultTaskDetailPage.routeName,
      extra: PersonResultTaskDetailArgs(employee: employee, task: task),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(personResultDetailTableWidthsProvider);
    final dividerWidths = <double>[
      ...state.columnOrder.map(state.widthFor),
      if (PersonResultDetailTableConfig.showActions) PersonResultDetailTableConfig.actionsWidth.w,
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder, width: 1.w),
        ),
      ),
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
              for (final column in state.columnOrder)
                _DataCell(width: state.widthFor(column), child: _buildCellContent(context, loc, column)),
              if (PersonResultDetailTableConfig.showActions)
                _DataCell(
                  width: PersonResultDetailTableConfig.actionsWidth.w,
                  child: DigifyAssetButton(
                    assetPath: Assets.icons.employeeManagement.more.path,
                    onTap: () => _openTaskDetail(context),
                    width: 18.w,
                    height: 18.w,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCellContent(BuildContext context, AppLocalizations loc, PersonResultDetailTableColumn column) {
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.grayBorderDark;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final statusLabel = task.statusLabel(
      completeLabel: loc.payrollPersonResultsTaskStatusComplete,
      inProgressLabel: loc.payrollPersonResultsTaskStatusInProgress,
    );

    return switch (column) {
      PersonResultDetailTableColumn.taskName => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _openTaskDetail(context),
          child: Text(
            task.taskName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
        ),
      ),
      PersonResultDetailTableColumn.status => Align(
        alignment: Alignment.centerLeft,
        child: DigifyStatusCapsule(status: statusLabel),
      ),
      PersonResultDetailTableColumn.flowName => Text(
        task.flowName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(color: primaryTextColor),
      ),
      PersonResultDetailTableColumn.processDate => Text(
        task.processDate,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(color: secondaryTextColor),
      ),
      PersonResultDetailTableColumn.payroll => Text(
        task.payroll,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(color: secondaryTextColor),
      ),
      PersonResultDetailTableColumn.payrollPeriod => Text(
        task.payrollPeriod,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(color: secondaryTextColor),
      ),
      PersonResultDetailTableColumn.amount => Text(
        task.amount,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
    };
  }
}

class _DividerCell extends StatelessWidget {
  const _DividerCell({required this.width, required this.isLast});

  final double width;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isLast ? Colors.transparent : AppColors.cardBorder, width: 1.w),
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 16.h),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }
}
