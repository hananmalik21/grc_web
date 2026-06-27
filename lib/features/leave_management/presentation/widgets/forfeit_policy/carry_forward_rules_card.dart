import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CarryForwardRulesCard extends StatefulWidget {
  final bool isDark;
  final String? maxCarryForwardDays;
  final String? gracePeriodDays;
  final bool requireManagerApproval;
  final ValueChanged<String>? onMaxCarryForwardChanged;
  final ValueChanged<String>? onGracePeriodChanged;
  final ValueChanged<bool>? onRequireManagerApprovalChanged;

  const CarryForwardRulesCard({
    super.key,
    required this.isDark,
    this.maxCarryForwardDays,
    this.gracePeriodDays,
    this.requireManagerApproval = false,
    this.onMaxCarryForwardChanged,
    this.onGracePeriodChanged,
    this.onRequireManagerApprovalChanged,
  });

  @override
  State<CarryForwardRulesCard> createState() => _CarryForwardRulesCardState();
}

class _CarryForwardRulesCardState extends State<CarryForwardRulesCard> {
  late TextEditingController _maxCarryForwardController;
  late TextEditingController _gracePeriodController;
  late bool _requireManagerApproval;

  @override
  void initState() {
    super.initState();
    _maxCarryForwardController = TextEditingController(text: widget.maxCarryForwardDays ?? '10');
    _gracePeriodController = TextEditingController(text: widget.gracePeriodDays ?? '90');
    _requireManagerApproval = widget.requireManagerApproval;
  }

  @override
  void didUpdateWidget(CarryForwardRulesCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.maxCarryForwardDays != oldWidget.maxCarryForwardDays) {
      _maxCarryForwardController.text = widget.maxCarryForwardDays ?? '10';
    }
    if (widget.gracePeriodDays != oldWidget.gracePeriodDays) {
      _gracePeriodController.text = widget.gracePeriodDays ?? '90';
    }
    if (widget.requireManagerApproval != oldWidget.requireManagerApproval) {
      _requireManagerApproval = widget.requireManagerApproval;
    }
  }

  @override
  void dispose() {
    _maxCarryForwardController.dispose();
    _gracePeriodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.leaveManagementIcon.path,
                width: 20,
                height: 20,
                color: AppColors.primary,
              ),
              Gap(7.w),
              Text(
                'Carry Forward Rules',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 14.sp,
                  color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(14.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.h,
            children: [
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
                          controller: _maxCarryForwardController,
                          labelText: 'Maximum Carry Forward Days',
                          hintText: 'Enter days',
                          filled: true,
                          fillColor: AppColors.cardBackground,
                          onChanged: widget.onMaxCarryForwardChanged,
                        ),
                        Text(
                          'Maximum days allowed to carry to next year',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
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
                          controller: _gracePeriodController,
                          labelText: 'Grace Period (Days)',
                          hintText: 'Enter days',
                          filled: true,
                          fillColor: AppColors.cardBackground,
                          onChanged: widget.onGracePeriodChanged,
                        ),
                        Text(
                          'Days to use carried leave before forfeit',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: widget.isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.roleBadgeBg,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: widget.isDark ? AppColors.infoBorderDark : AppColors.permissionBadgeBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DigifyCheckbox(
                      value: _requireManagerApproval,
                      onChanged: widget.onRequireManagerApprovalChanged != null
                          ? (value) {
                              setState(() {
                                _requireManagerApproval = value ?? false;
                              });
                              widget.onRequireManagerApprovalChanged?.call(_requireManagerApproval);
                            }
                          : null,
                    ),
                    Gap(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4.h,
                        children: [
                          Text(
                            'Require Manager Approval',
                            style: context.textTheme.titleSmall?.copyWith(
                              color: widget.isDark ? AppColors.infoTextDark : AppColors.statIconBlue,
                            ),
                          ),
                          Text(
                            'Carry forward requires explicit manager approval',
                            style: context.textTheme.labelSmall?.copyWith(
                              fontSize: 12.sp,
                              color: widget.isDark
                                  ? AppColors.infoTextDark.withValues(alpha: 0.8)
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
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
