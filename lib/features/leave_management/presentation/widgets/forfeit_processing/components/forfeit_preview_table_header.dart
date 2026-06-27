import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/data/config/forfeit_preview_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForfeitPreviewTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const ForfeitPreviewTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (ForfeitPreviewTableConfig.showEmployee) {
      headerCells.add(_buildHeaderCell(context, localizations.employee, ForfeitPreviewTableConfig.employeeWidth.w));
    }
    if (ForfeitPreviewTableConfig.showDepartment) {
      headerCells.add(_buildHeaderCell(context, localizations.department, ForfeitPreviewTableConfig.departmentWidth.w));
    }
    if (ForfeitPreviewTableConfig.showLeaveType) {
      headerCells.add(_buildHeaderCell(context, localizations.leaveType, ForfeitPreviewTableConfig.leaveTypeWidth.w));
    }
    if (ForfeitPreviewTableConfig.showTotalBalance) {
      headerCells.add(
        _buildHeaderCell(
          context,
          localizations.totalBalance,
          ForfeitPreviewTableConfig.totalBalanceWidth.w,
          center: true,
        ),
      );
    }
    if (ForfeitPreviewTableConfig.showCarryLimit) {
      headerCells.add(
        _buildHeaderCell(context, 'Carry Limit', ForfeitPreviewTableConfig.carryLimitWidth.w, center: true),
      );
    }
    if (ForfeitPreviewTableConfig.showForfeitDays) {
      headerCells.add(
        _buildHeaderCell(context, 'Forfeit Days', ForfeitPreviewTableConfig.forfeitDaysWidth.w, center: true),
      );
    }
    if (ForfeitPreviewTableConfig.showExpiryDate) {
      headerCells.add(
        _buildHeaderCell(context, localizations.expiryDate, ForfeitPreviewTableConfig.expiryDateWidth.w, center: true),
      );
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width, {bool center = false}) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(text, style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText)),
    );
  }
}
