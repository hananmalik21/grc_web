import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApprovalWorkflowCard extends StatelessWidget {
  final ApprovalWorkflows approval;
  final bool isDark;

  const ApprovalWorkflowCard({super.key, required this.approval, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          EligibilitySubsectionHeader(
            title: 'Approval Workflow',
            iconPath: Assets.icons.leaveManagement.martialStatus.path,
            isDark: isDark,
          ),
          Row(
            spacing: 16.w,
            children: [
              Flexible(
                child: DigifyCheckbox(value: approval.approvalWorkflow == 'Manager', onChanged: null, label: 'Manager'),
              ),
              Flexible(
                child: DigifyCheckbox(value: approval.approvalWorkflow == 'HR', onChanged: null, label: 'HR'),
              ),
              Flexible(
                child: DigifyCheckbox(
                  value: approval.approvalWorkflow == 'Executive' || approval.approvalWorkflow == 'Automate',
                  onChanged: null,
                  label: 'Executive',
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.h,
            children: [
              DigifyTextField.number(
                controller: TextEditingController(text: approval.autoApprovalThreshold),
                labelText: 'Auto-Approval Threshold (days)',
                hintText: 'Enter threshold',
                filled: true,
                fillColor: AppColors.cardBackground,
              ),
              Text(
                'Leave requests ≤ this value are auto-approved',
                style: context.textTheme.labelSmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
