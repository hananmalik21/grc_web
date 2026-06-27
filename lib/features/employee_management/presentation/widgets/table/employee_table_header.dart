import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/employee_management/data/config/manage_employees_table_config.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeTableHeader extends ConsumerWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const EmployeeTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final widths = ref.watch(manageEmployeesTableWidthsProvider);

    final headerCells = <Widget>[];

    if (ManageEmployeesTableConfig.showIndex) {
      headerCells.add(_buildHeaderCell(context, '#', widths.index, ManageEmployeesColumn.rowNumber, ref));
    }
    if (ManageEmployeesTableConfig.showEmployee) {
      headerCells.add(_buildHeaderCell(context, localizations.employee, widths.employee, ManageEmployeesColumn.employee, ref));
    }
    if (ManageEmployeesTableConfig.showPosition) {
      headerCells.add(
        _buildHeaderCell(context, localizations.position, widths.position, ManageEmployeesColumn.position, ref),
      );
    }
    if (ManageEmployeesTableConfig.showDepartment) {
      headerCells.add(
        _buildHeaderCell(context, localizations.department, widths.department, ManageEmployeesColumn.department, ref),
      );
    }
    if (ManageEmployeesTableConfig.showEmail) {
      headerCells.add(_buildHeaderCell(context, localizations.email, widths.email, ManageEmployeesColumn.email, ref));
    }
    if (ManageEmployeesTableConfig.showPhone) {
      headerCells.add(
        _buildHeaderCell(context, localizations.phoneNumber, widths.phone, ManageEmployeesColumn.phone, ref),
      );
    }
    if (ManageEmployeesTableConfig.showStatus) {
      headerCells.add(_buildHeaderCell(context, localizations.status, widths.status, ManageEmployeesColumn.status, ref));
    }
    if (ManageEmployeesTableConfig.showActions) {
      headerCells.add(
        _buildHeaderCell(context, localizations.actions, widths.actions, ManageEmployeesColumn.actions, ref, isLast: true),
      );
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String text,
    double width,
    ManageEmployeesColumn column,
    WidgetRef ref, {
    bool isLast = false,
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
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: ManageEmployeesTableConfig.cellPaddingHorizontal.w,
              vertical: 14.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              text.toUpperCase(),
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
                  ref.read(manageEmployeesTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
