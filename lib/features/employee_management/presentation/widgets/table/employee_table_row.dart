import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/employee_management/data/config/manage_employees_table_config.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_table_width_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeTableRow extends ConsumerWidget {
  final EmployeeListItem employee;
  final int index;
  final AppLocalizations localizations;
  final Function(EmployeeListItem)? onView;
  final Function(EmployeeListItem)? onEdit;
  final VoidCallback? onMore;

  const EmployeeTableRow({
    super.key,
    required this.employee,
    required this.index,
    required this.localizations,
    this.onView,
    this.onEdit,
    this.onMore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final widths = ref.watch(manageEmployeesTableWidthsProvider);
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
    final secondaryStyle = context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onView == null ? null : () => onView!(employee),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Row(
                  children: [
                    if (ManageEmployeesTableConfig.showIndex) _buildDivider(widths.index, isDark),
                    if (ManageEmployeesTableConfig.showEmployee) _buildDivider(widths.employee, isDark),
                    if (ManageEmployeesTableConfig.showPosition) _buildDivider(widths.position, isDark),
                    if (ManageEmployeesTableConfig.showDepartment) _buildDivider(widths.department, isDark),
                    if (ManageEmployeesTableConfig.showEmail) _buildDivider(widths.email, isDark),
                    if (ManageEmployeesTableConfig.showPhone) _buildDivider(widths.phone, isDark),
                    if (ManageEmployeesTableConfig.showStatus) _buildDivider(widths.status, isDark),
                    if (ManageEmployeesTableConfig.showActions) _buildDivider(widths.actions, isDark, isLast: true),
                  ],
                ),
              ),
              Row(
                children: [
                  if (ManageEmployeesTableConfig.showIndex)
                    _buildDataCell(Text('$index', style: textStyle), widths.index),
                  if (ManageEmployeesTableConfig.showEmployee)
                    _buildDataCell(
                      Row(
                        children: [
                          AppAvatar(image: null, fallbackInitial: employee.fullName, size: 40.w),
                          Gap(12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  employee.fullNameDisplay.toUpperCase(),
                                  style: textStyle?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Gap(2.h),
                                Text(
                                  employee.employeeIdDisplay,
                                  style: secondaryStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      widths.employee,
                    ),
                  if (ManageEmployeesTableConfig.showPosition)
                    _buildDataCell(
                      Text(employee.positionDisplay, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                      widths.position,
                    ),
                  if (ManageEmployeesTableConfig.showDepartment)
                    _buildDataCell(
                      Text(
                        employee.departmentDisplay.toUpperCase(),
                        style: textStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      widths.department,
                    ),
                  if (ManageEmployeesTableConfig.showEmail)
                    _buildDataCell(
                      Text(employee.emailDisplay, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                      widths.email,
                    ),
                  if (ManageEmployeesTableConfig.showPhone)
                    _buildDataCell(
                      Text(employee.phoneDisplay, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                      widths.phone,
                    ),
                  if (ManageEmployeesTableConfig.showStatus) _buildDataCell(_buildStatusCapsule(), widths.status),
                  if (ManageEmployeesTableConfig.showActions)
                    _buildDataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8.w,
                        children: [
                          if (onView != null)
                            ActionButtonWidget(
                              type: ActionButtonType.view,
                              onTap: () => onView!(employee),
                              width: 18.w,
                              height: 18.w,
                              padding: 6.w,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          if (onEdit != null)
                            ActionButtonWidget(
                              type: ActionButtonType.edit,
                              onTap: () => onEdit!(employee),
                              width: 18.w,
                              height: 18.w,
                              padding: 6.w,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          if (onMore != null)
                            ActionButtonWidget(
                              icon: Assets.icons.employeeManagement.more.path,
                              tooltip: 'More',
                              onTap: () => onMore!,
                              width: 18.w,
                              height: 18.w,
                              padding: 6.w,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                        ],
                      ),
                      widths.actions,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCapsule() {
    final isProbation = employee.status.toLowerCase().contains('probation');
    final label = employee.statusDisplay.toUpperCase();
    return DigifyCapsule(
      label: label,
      backgroundColor: isProbation ? AppColors.warningBg : AppColors.activeStatusBg,
      textColor: isProbation ? AppColors.warningText : AppColors.successText,
      borderColor: isProbation ? AppColors.warningBorder : AppColors.activeStatusBorder,
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: ManageEmployeesTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }

  Widget _buildDivider(double width, bool isDark, {bool isLast = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
              ),
      ),
    );
  }
}
