import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/leave_management/domain/models/team_leave_risk_employee.dart';
import 'package:grc/features/leave_management/presentation/widgets/team_leave_risk/components/team_leave_risk_table_header.dart';
import 'package:grc/features/leave_management/presentation/widgets/team_leave_risk/components/team_leave_risk_table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamLeaveRiskTable extends StatelessWidget {
  final List<TeamLeaveRiskEmployee> employees;
  final AppLocalizations localizations;
  final bool isDark;
  final ValueChanged<TeamLeaveRiskEmployee>? onView;
  final ValueChanged<TeamLeaveRiskEmployee>? onApprove;

  const TeamLeaveRiskTable({
    super.key,
    required this.employees,
    required this.localizations,
    required this.isDark,
    this.onView,
    this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollableSingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                TeamLeaveRiskTableHeader(isDark: isDark, localizations: localizations),
                ...employees.map(
                  (employee) => TeamLeaveRiskTableRow(
                    employee: employee,
                    localizations: localizations,
                    onView: onView != null ? () => onView!(employee) : null,
                    onApprove: onApprove != null ? () => onApprove!(employee) : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
