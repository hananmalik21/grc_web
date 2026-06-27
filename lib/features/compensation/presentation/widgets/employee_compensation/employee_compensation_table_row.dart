import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/compensation/presentation/models/employee_compensation_table_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_table_width_provider.dart';
import 'package:grc/features/compensation/presentation/screens/employee_compensation/employee_compensation_detail_page.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/employee_compensation_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'employee_compensation_table_config.dart';
import 'employee_compensation_table_types.dart';

class EmployeeCompensationTableRow extends ConsumerWidget with EmployeeCompensationPermissionMixin {
  final EmployeeCompensationTableRowData row;
  final bool isDark;

  const EmployeeCompensationTableRow({super.key, required this.row, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeCompensationTableWidthsProvider);

    final dividerWidths = <double>[
      ...state.columnOrder.map(state.widthFor),
      EmployeeCompensationTableConfig.actionsWidth.w,
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
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
                _DataCell(
                  width: state.widthFor(column),
                  alignment: _cellAlignment(column),
                  child: _buildCellContent(context, column),
                ),
              _DataCell(
                width: EmployeeCompensationTableConfig.actionsWidth.w,
                alignment: Alignment.centerLeft,
                child: canViewEmployeeCompensation
                    ? ActionButtonWidget(
                        type: ActionButtonType.view,
                        onTap: () {
                          context.pushNamed(
                            EmployeeCompensationDetailPage.routeName,
                            extra: {'employeeGuid': row.employeeGuid, 'planGuid': row.planGuid},
                          );
                        },
                        width: 18.w,
                        height: 18.w,
                        padding: 6.w,
                        borderRadius: BorderRadius.circular(6.r),
                        customBorder: null,
                      )
                    : Text('No Actions available', style: context.textTheme.labelSmall),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCellContent(BuildContext context, EmployeeCompensationTableColumn column) {
    return switch (column) {
      EmployeeCompensationTableColumn.employee => _EmployeeInfoCell(row: row, isDark: isDark),
      EmployeeCompensationTableColumn.department => _BodyText(
        text: row.department,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      EmployeeCompensationTableColumn.region => Align(
        alignment: Alignment.centerLeft,
        child: DigifyCapsule(
          label: row.region,
          backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
          textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
      EmployeeCompensationTableColumn.position => _BodyText(
        text: row.position,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      EmployeeCompensationTableColumn.compensationPlan => _BodyText(
        text: row.compensationPlan,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      EmployeeCompensationTableColumn.salaryStructure => _BodyText(
        text: row.salaryStructure,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
      EmployeeCompensationTableColumn.grade => Align(
        alignment: Alignment.centerLeft,
        child: DigifyCapsule(
          label: row.grade,
          backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
          textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
      EmployeeCompensationTableColumn.baseSalary => _AmountText(
        label: row.baseSalaryLabel,
        isEmphasized: true,
        isDark: isDark,
      ),
      EmployeeCompensationTableColumn.allowances => _AmountText(label: row.allowancesLabel, isDark: isDark),
      EmployeeCompensationTableColumn.benefits => _AmountText(label: row.benefitsLabel, isDark: isDark),
      EmployeeCompensationTableColumn.totalComp => _AmountText(
        label: row.totalCompensationLabel,
        isEmphasized: true,
        isDark: isDark,
      ),
      EmployeeCompensationTableColumn.status => Align(
        alignment: Alignment.centerLeft,
        child: DigifyStatusCapsule(status: row.status),
      ),
    };
  }

  Alignment _cellAlignment(EmployeeCompensationTableColumn column) {
    return Alignment.centerLeft;
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

class _DataCell extends StatelessWidget {
  final double width;
  final Widget child;
  final Alignment alignment;

  const _DataCell({required this.width, required this.child, this.alignment = Alignment.centerLeft});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Align(alignment: alignment, child: child),
      ),
    );
  }
}

class _EmployeeInfoCell extends StatelessWidget {
  final EmployeeCompensationTableRowData row;
  final bool isDark;

  const _EmployeeInfoCell({required this.row, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          row.employeeName,
          style: context.textTheme.labelMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(2.h),
        Text(
          row.employeeId,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            height: 1.35,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  final Color color;

  const _BodyText({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodySmall?.copyWith(fontSize: 14.sp, height: 1.45, color: color),
    );
  }
}

class _AmountText extends StatelessWidget {
  final String label;
  final bool isEmphasized;
  final bool isDark;

  const _AmountText({required this.label, this.isEmphasized = false, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: context.textTheme.bodySmall?.copyWith(
          fontSize: 14.sp,
          height: 1.45,
          fontWeight: isEmphasized ? FontWeight.w600 : FontWeight.w400,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
    );
  }
}
