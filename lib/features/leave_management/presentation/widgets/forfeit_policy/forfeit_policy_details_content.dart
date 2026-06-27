import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_policy.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_policy/calculation_method_card.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_policy/carry_forward_rules_card.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_policy/encashment_option_card.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_policy/exceptions_exemptions_card.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_policy/forfeit_policy_header.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_policy/forfeit_triggers_card.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_policy/notification_settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForfeitPolicyDetailsContent extends StatelessWidget {
  final ForfeitPolicy? selectedForfeitPolicy;
  final bool isDark;

  const ForfeitPolicyDetailsContent({super.key, this.selectedForfeitPolicy, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (selectedForfeitPolicy == null) {
      return Center(
        child: Text(
          'Select a forfeit policy to view details',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        ForfeitPolicyHeader(
          policyName: selectedForfeitPolicy!.name,
          policyNameArabic: selectedForfeitPolicy!.nameArabic,
          isPolicyActive: selectedForfeitPolicy!.isActive,
          isForfeitEnabled: true,
          isDark: isDark,
          onEditPressed: () {},
        ),
        ForfeitTriggersCard(isDark: isDark, onTriggerChanged: (triggerId) {}),
        CarryForwardRulesCard(
          isDark: isDark,
          maxCarryForwardDays: '10',
          gracePeriodDays: '90',
          requireManagerApproval: false,
          onMaxCarryForwardChanged: (value) {},
          onGracePeriodChanged: (value) {},
          onRequireManagerApprovalChanged: (value) {},
        ),
        CalculationMethodCard(
          isDark: isDark,
          selectedMethod: CalculationMethod.gracePeriod,
          gracePeriodDuration: '90',
          notificationAdvance: '30',
          onMethodChanged: (method) {},
          onGracePeriodChanged: (value) {},
          onNotificationAdvanceChanged: (value) {},
        ),
        ExceptionsExemptionsCard(
          isDark: isDark,
          exemptSeniorManagement: false,
          longServiceExemption: false,
          minimumYearsOfService: '10',
          exemptGrades: 'Executive, Senior Manager',
          onExemptSeniorManagementChanged: (value) {},
          onLongServiceExemptionChanged: (value) {},
          onMinimumYearsChanged: (value) {},
          onExemptGradesChanged: (value) {},
        ),
        EncashmentOptionCard(
          isDark: isDark,
          allowEncashment: false,
          maxEncashmentDays: '15',
          encashmentRate: '100',
          onAllowEncashmentChanged: (value) {},
          onMaxEncashmentDaysChanged: (value) {},
          onEncashmentRateChanged: (value) {},
        ),
        NotificationSettingsCard(
          isDark: isDark,
          notifyEmployees: true,
          notifyDirectManagers: true,
          notifyHRDepartment: true,
          advanceNotificationDays: '90, 60, 30, 7',
          onNotifyEmployeesChanged: (value) {},
          onNotifyDirectManagersChanged: (value) {},
          onNotifyHRDepartmentChanged: (value) {},
          onAdvanceNotificationDaysChanged: (value) {},
        ),
      ],
    );
  }
}
