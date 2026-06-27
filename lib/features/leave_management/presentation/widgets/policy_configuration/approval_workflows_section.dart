import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ApprovalWorkflowsSection extends StatelessWidget {
  final bool isDark;
  final ApprovalWorkflows approval;

  const ApprovalWorkflowsSection({super.key, required this.isDark, required this.approval});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Approval Workflows',
      iconPath: Assets.icons.leaveManagement.request.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          RadioGroup<String>(
            groupValue: approval.approvalWorkflow,
            onChanged: (_) {},
            child: Row(
              children: [
                Radio<String>(value: 'Manager', activeColor: AppColors.primary),
                Text('Manager', style: context.textTheme.bodyMedium),
                Gap(16.w),
                Radio<String>(value: 'HR', activeColor: AppColors.primary),
                Text('HR', style: context.textTheme.bodyMedium),
                Gap(16.w),
                Radio<String>(value: 'Automate', activeColor: AppColors.primary),
                Text('Automate', style: context.textTheme.bodyMedium),
              ],
            ),
          ),
          DigifyTextField.number(
            controller: TextEditingController(text: approval.autoApprovalThreshold),
            labelText: 'Auto-Approval Threshold (days)',
            hintText: 'e.g., 0',
            enabled: false,
          ),
          Text(
            'Leave requests within this threshold will be automatically approved',
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
