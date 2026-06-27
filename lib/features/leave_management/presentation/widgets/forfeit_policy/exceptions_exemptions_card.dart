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

class ExceptionsExemptionsCard extends StatefulWidget {
  final bool isDark;
  final bool exemptSeniorManagement;
  final bool longServiceExemption;
  final String? minimumYearsOfService;
  final String? exemptGrades;
  final ValueChanged<bool>? onExemptSeniorManagementChanged;
  final ValueChanged<bool>? onLongServiceExemptionChanged;
  final ValueChanged<String>? onMinimumYearsChanged;
  final ValueChanged<String>? onExemptGradesChanged;

  const ExceptionsExemptionsCard({
    super.key,
    required this.isDark,
    this.exemptSeniorManagement = false,
    this.longServiceExemption = false,
    this.minimumYearsOfService,
    this.exemptGrades,
    this.onExemptSeniorManagementChanged,
    this.onLongServiceExemptionChanged,
    this.onMinimumYearsChanged,
    this.onExemptGradesChanged,
  });

  @override
  State<ExceptionsExemptionsCard> createState() => _ExceptionsExemptionsCardState();
}

class _ExceptionsExemptionsCardState extends State<ExceptionsExemptionsCard> {
  late bool _exemptSeniorManagement;
  late bool _longServiceExemption;
  late TextEditingController _minimumYearsController;
  late TextEditingController _exemptGradesController;

  @override
  void initState() {
    super.initState();
    _exemptSeniorManagement = widget.exemptSeniorManagement;
    _longServiceExemption = widget.longServiceExemption;
    _minimumYearsController = TextEditingController(text: widget.minimumYearsOfService ?? '10');
    _exemptGradesController = TextEditingController(text: widget.exemptGrades ?? 'Executive, Senior Manager');
  }

  @override
  void didUpdateWidget(ExceptionsExemptionsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.exemptSeniorManagement != oldWidget.exemptSeniorManagement) {
      _exemptSeniorManagement = widget.exemptSeniorManagement;
    }
    if (widget.longServiceExemption != oldWidget.longServiceExemption) {
      _longServiceExemption = widget.longServiceExemption;
    }
    if (widget.minimumYearsOfService != oldWidget.minimumYearsOfService) {
      _minimumYearsController.text = widget.minimumYearsOfService ?? '10';
    }
    if (widget.exemptGrades != oldWidget.exemptGrades) {
      _exemptGradesController.text = widget.exemptGrades ?? 'Executive, Senior Manager';
    }
  }

  @override
  void dispose() {
    _minimumYearsController.dispose();
    _exemptGradesController.dispose();
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
                assetPath: Assets.icons.leaveManagement.shield.path,
                width: 20,
                height: 20,
                color: AppColors.primary,
              ),
              Gap(7.w),
              Text(
                'Exceptions & Exemptions',
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
            spacing: 12.h,
            children: [
              _ExemptionCard(
                label: 'Exempt Senior Management',
                description: 'Executive and C-level positions exempt from forfeit',
                isSelected: _exemptSeniorManagement,
                isDark: widget.isDark,
                backgroundColor: widget.isDark ? AppColors.successBgDark.withValues(alpha: 0.2) : AppColors.greenBg,
                borderColor: widget.isDark ? AppColors.successBorderDark : AppColors.greenBorder,
                textColor: widget.isDark ? AppColors.successTextDark : AppColors.greenText,
                onTap: () {
                  setState(() {
                    _exemptSeniorManagement = !_exemptSeniorManagement;
                  });
                  widget.onExemptSeniorManagementChanged?.call(_exemptSeniorManagement);
                },
              ),
              _LongServiceExemptionCard(
                isSelected: _longServiceExemption,
                minimumYearsController: _minimumYearsController,
                isDark: widget.isDark,
                onToggle: () {
                  setState(() {
                    _longServiceExemption = !_longServiceExemption;
                  });
                  widget.onLongServiceExemptionChanged?.call(_longServiceExemption);
                },
                onYearsChanged: (value) {
                  widget.onMinimumYearsChanged?.call(value);
                },
              ),
            ],
          ),
          Gap(16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.h,
            children: [
              DigifyTextField(
                controller: _exemptGradesController,
                labelText: 'Exempt Specific Grades',
                hintText: 'Enter grades',
                filled: true,
                fillColor: AppColors.cardBackground,
                onChanged: widget.onExemptGradesChanged,
              ),
              Text(
                'Comma-separated list of exempt grades',
                style: context.textTheme.labelSmall?.copyWith(
                  color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExemptionCard extends StatelessWidget {
  final String label;
  final String description;
  final bool isSelected;
  final bool isDark;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ExemptionCard({
    required this.label,
    required this.description,
    required this.isSelected,
    required this.isDark,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyCheckbox(value: isSelected, onChanged: (value) => onTap()),
            Gap(11.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3.h,
                children: [
                  Text(label, style: context.textTheme.titleSmall?.copyWith(color: textColor)),
                  Text(
                    description,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 12.sp,
                      color: isDark ? textColor.withValues(alpha: 0.8) : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LongServiceExemptionCard extends StatelessWidget {
  final bool isSelected;
  final TextEditingController minimumYearsController;
  final bool isDark;
  final VoidCallback onToggle;
  final ValueChanged<String> onYearsChanged;

  const _LongServiceExemptionCard({
    required this.isSelected,
    required this.minimumYearsController,
    required this.isDark,
    required this.onToggle,
    required this.onYearsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.infoBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.h,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifyCheckbox(value: isSelected, onChanged: (value) => onToggle()),
                Gap(11.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 3.h,
                    children: [
                      Text(
                        'Long Service Exemption',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.infoTextDark : AppColors.infoText,
                        ),
                      ),
                      Text(
                        'Employees with long tenure get special consideration',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 12.sp,
                          color: isDark ? AppColors.infoTextDark.withValues(alpha: 0.8) : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 28.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.h,
                children: [
                  SizedBox(
                    width: 150.w,
                    child: DigifyTextField.number(
                      controller: minimumYearsController,
                      labelText: 'Minimum Years of Service',
                      hintText: 'Enter years',
                      filled: true,
                      fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                      onChanged: onYearsChanged,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
