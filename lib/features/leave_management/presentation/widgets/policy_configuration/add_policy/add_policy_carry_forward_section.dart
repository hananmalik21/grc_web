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

/// Carry forward rules section for the Add Policy dialog.
class AddPolicyCarryForwardSection extends StatefulWidget {
  const AddPolicyCarryForwardSection({
    super.key,
    required this.isDark,
    required this.carryForward,
    required this.notifier,
  });

  final bool isDark;
  final CarryForwardRules carryForward;
  final PolicyDraftNotifier notifier;

  @override
  State<AddPolicyCarryForwardSection> createState() => _AddPolicyCarryForwardSectionState();
}

class _AddPolicyCarryForwardSectionState extends State<AddPolicyCarryForwardSection> {
  late TextEditingController _limitController;
  late TextEditingController _graceController;

  @override
  void initState() {
    super.initState();
    _limitController = TextEditingController();
    _graceController = TextEditingController();
  }

  @override
  void dispose() {
    _limitController.dispose();
    _graceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final notifier = widget.notifier;
    return ExpandableConfigSection(
      title: 'Carry Forward Rules',
      iconPath: Assets.icons.clockIcon.path,
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
                  value: widget.carryForward.allowCarryForward,
                  onChanged: (v) => notifier.updateAllowCarryForward(v ?? false),
                  label: 'Allow Carry Forward to Next Year',
                ),
                Padding(
                  padding: EdgeInsets.only(left: 23.w),
                  child: Text(
                    'Enable employees to carry unused leave to the following year',
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
                      labelText: 'Carry Forward Limit (days)',
                      hintText: '0',
                      filled: true,
                      fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                      readOnly: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) => notifier.updateCarryForwardLimitDays(int.tryParse(v)),
                    ),
                    Text(
                      'Maximum days allowed to carry forward',
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
                      controller: _graceController,
                      labelText: 'Grace Period (days)',
                      hintText: '0',
                      filled: true,
                      fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                      readOnly: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) => notifier.updateGracePeriodDays(int.tryParse(v)),
                    ),
                    Text(
                      'Days after year-end to use carried leave',
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
