import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balance_tab/employee_info_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeInfoCard extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final Map<String, dynamic> employeeData;

  const EmployeeInfoCard({super.key, required this.localizations, required this.isDark, required this.employeeData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: EmployeeInfoField(
              label: localizations.employeeName,
              value: employeeData['name'] as String,
              isDark: isDark,
            ),
          ),
          Expanded(
            child: EmployeeInfoField(
              label: localizations.employeeNumber,
              value: employeeData['employeeNumber'] as String,
              isDark: isDark,
            ),
          ),
          Expanded(
            child: EmployeeInfoField(
              label: localizations.department,
              value: employeeData['department'] as String,
              isDark: isDark,
            ),
          ),
          Expanded(
            child: EmployeeInfoField(
              label: localizations.joinDate,
              value: employeeData['joinDate'] as String,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}
