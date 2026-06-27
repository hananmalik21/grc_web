import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Encashment rules section for the Add Policy dialog.
class AddPolicyEncashmentSection extends StatefulWidget {
  const AddPolicyEncashmentSection({super.key, required this.isDark, required this.encashment, required this.notifier});

  final bool isDark;
  final EncashmentRules encashment;
  final PolicyDraftNotifier notifier;

  @override
  State<AddPolicyEncashmentSection> createState() => _AddPolicyEncashmentSectionState();
}

class _AddPolicyEncashmentSectionState extends State<AddPolicyEncashmentSection> {
  late TextEditingController _limitController;
  late TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    _limitController = TextEditingController();
    _rateController = TextEditingController();
  }

  @override
  void dispose() {
    _limitController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final notifier = widget.notifier;
    return ExpandableConfigSection(
      title: 'Encashment Rules',
      iconPath: Assets.icons.leaveManagement.dollar.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                DigifyCheckbox(
                  value: widget.encashment.allowLeaveEncashment,
                  onChanged: (v) => notifier.updateAllowEncashment(v ?? false),
                  label: 'Allow Leave Encashment',
                ),
                Padding(
                  padding: EdgeInsets.only(left: 23.w),
                  child: Text(
                    'Enable employees to request monetary compensation for unused leave',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            spacing: 12.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    DigifyTextField.number(
                      controller: _limitController,
                      labelText: 'Encashment Limit (days)',
                      hintText: '0',
                      filled: true,
                      fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                      readOnly: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) => notifier.updateEncashmentLimitDays(int.tryParse(v)),
                    ),
                    Text(
                      'Maximum days allowed for encashment per year',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    DigifyTextField.number(
                      controller: _rateController,
                      labelText: 'Encashment Rate (%)',
                      hintText: '0',
                      filled: true,
                      fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                      readOnly: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) => notifier.updateEncashmentRatePct(int.tryParse(v)),
                    ),
                    Text(
                      'Percentage of daily wage paid',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
